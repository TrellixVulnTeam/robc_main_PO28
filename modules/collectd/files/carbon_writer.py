# Copyright 2010 Gregory Szorc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
import collectd
import errno
import socket
from time import time
from traceback import format_exc

host = None
port = None
derive = False
types = {}

def carbon_parse_types_file(path):
    global types

    f = open(path, 'r')

    for line in f:
        fields = line.split()
        if len(fields) < 2:
            continue

        type_name = fields[0]

        if type_name[0] == '#':
            continue

        v = []
        for ds in fields[1:]:
            ds = ds.rstrip(',')
            ds_fields = ds.split(':')

            if len(ds_fields) != 4:
                collectd.warning('carbon_writer: cannot parse data source %s on type %s' % ( ds, type_name ))
                continue

            v.append(ds_fields)

        types[type_name] = v

    f.close()

def carbon_config(c):
    global host, port, derive

    for child in c.children:
        if child.key == 'LineReceiverHost':
            host = child.values[0]
        elif child.key == 'LineReceiverPort':
            port = int(child.values[0])
        elif child.key == 'TypesDB':
            for v in child.values:
                carbon_parse_types_file(v)
        elif child.key == 'DeriveCounters':
            derive = True

    if not host:
        raise Exception('LineReceiverHost not defined')

    if not port:
        raise Exception('LineReceiverPort not defined')

def carbon_init():
    global host, port, derive
    import threading

    d = {
        'host': host,
        'port': port,
        'derive': derive,
        'sock': None,
        'lock': threading.Lock(),
        'values': { },
        'last_connect_time': 0
    }

    carbon_connect(d)

    collectd.register_write(carbon_write, data=d)

def carbon_connect(data):
    result = False

    if not data['sock']:
        # only attempt reconnect every 10 seconds
        now = time()
        if now - data['last_connect_time'] < 10:
            return False

        data['last_connect_time'] = now
        collectd.info('connecting to %s:%s' % ( data['host'], data['port'] ) )
        try:
            data['sock'] = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            data['sock'].connect((host, port))
            result = True
        except:
            result = False
            collectd.warning('error connecting socket: %s' % format_exc())
    else:
        result = True

    return result

def carbon_write_data(data, s):
    result = False
    data['lock'].acquire()
    try:
        data['sock'].sendall(s)
        result = True
    except socket.error, e:
        data['sock'] = None
        if isinstance(e.args, tuple):
            collectd.warning('carbon_writer: socket error %d' % e[0])
        else:
            collectd.warning('carbon_writer: socket error')
    except:
        collectd.warning('carbon_writer: error sending data: %s' % format_exc())

    data['lock'].release()
    return result

def carbon_write(v, data=None):
    data['lock'].acquire()
    if not carbon_connect(data):
        data['lock'].release()
        collectd.warning('carbon_writer: no connection to carbon server')
        return

    data['lock'].release()

    if v.type not in types:
        collectd.warning('carbon_writer: do not know how to handle type %s. do you have all your types.db files configured?' % v.type)
        return

    type = types[v.type]

    if len(type) != len(v.values):
        collectd.warning('carbon_writer: differing number of values for type %s' % v.type)
        return

    metric_fields = [ v.host.replace('.', '_') ]

    metric_fields.append(v.plugin)
    if v.plugin_instance:
        metric_fields.append(v.plugin_instance)

    metric_fields.append(v.type)
    if v.type_instance:
        metric_fields.append(v.type_instance)

    time = v.time

    # we update shared recorded values, so lock to prevent race conditions
    data['lock'].acquire()

    lines = []
    i = 0
    for value in v.values:
        ds_name = type[i][0]
        ds_type = type[i][1]

        path_fields = metric_fields[:]
        path_fields.append(ds_name)

        metric = '.'.join(path_fields)

        new_value = None

        # perform data normalization for COUNTER and DERIVE points
        if data['derive'] and (ds_type == 'COUNTER' or ds_type == 'DERIVE'):
            # we have an old value
            if metric in data['values']:
                min = type[i][2]
                max = type[i][3]

                if min == 'U':
                    min = 0

                old_value = data['values'][metric]

                # overflow
                if value < old_value:
                    # this is funky. pretend as if this is the first data point
                    if max == 'U':
                        new_value = None
                    else:
                        new_value = max - old_value + value - min
                else:
                    new_value = value - old_value

            # update previous value
            data['values'][metric] = value

        else:
            new_value = value

        if new_value is not None:
            line = '%s %f %d' % ( metric, new_value, time )
            lines.append(line)

        i += 1

    data['lock'].release()

    lines.append('')
    carbon_write_data(data, '\n'.join(lines))

collectd.register_config(carbon_config)
collectd.register_init(carbon_init)

