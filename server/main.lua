box.cfg {
    listen = 3301;
    log_level = 5;
    log_nonblock = false;
}

local function bootstrap()
    box.schema.user.create('user', {
        password='password',
        if_not_exists=true
    })

    box.schema.user.grant('user', 'read,write,execute',
        'universe', nil, {
        if_not_exists = true
    })

    local storage = box.schema.space.create('storage')
    storage:format({
        {'key', 'string', is_nullable=false},
        {'value', 'map', is_nullable=false}
    })

    storage:create_index('primary', {
        type='hash',
        parts={'key'}
    })
end

box.once('init', bootstrap)

local http_server = require('http.server')
local json = require('json')
local handlers =  {}

function handlers.add(req)
    local key = req:param('key')
    local value = req:param('value')

    if key == nil or value == nil then
        return {status = 400}
    end

    local kv = box.space.storage:get{key}
    if kv ~= nil then
        return {status = 409}
    end
    
    _ = box.space.storage:insert{key, value}

    return {status = 200}
end

function handlers.update(req)
    local key = req:stash('id')
    local value = req:param('value')
    
    if value == nil then
        return {status = 400}
    end

    local kv = box.space.storage:update(key, {{'=', 2, value}})
    if kv == nil then
        return {status = 404}
    end

    return {status = 200}
end

function handlers.get(req)
    local key = req:stash('id')

    local kv = box.space.storage:get{key}
    if kv == nil then
        return {status = 404}
    end
    
    return {
        status = 200,
        headers = { ['content-type'] = 'application/json; charset=utf8' },
        body = json.encode({key = kv["key"], value = kv["value"]})
    }
end

function handlers.delete(req)
    local key = req:stash('id')

    local kv = box.space.storage:delete{key}
    if kv == nil then
        return {status = 404}
    end

    return {status = 200}
end

local server = http_server.new(os.getenv("SERVER_HOST"), os.getenv("SERVER_PORT"), {
    log_requests = true,
    log_errors = true
})

server:route({method = 'POST', path = '/kv'}, handlers.add)
server:route({method = 'PUT', path = '/kv/:id'}, handlers.update)
server:route({method = 'GET', path = '/kv/:id'}, handlers.get)
server:route({method = 'DELETE', path = '/kv/:id'}, handlers.delete)

server:start()
