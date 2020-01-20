require! {
    \express
    \cors
    \express-rate-limit
    \express-http-proxy : proxy
    \greenlock-express : { create }
}

limit-config =
  windowMs: 150 * 60 * 1000
  max: 1000000

limiter = express-rate-limit limit-config


nodes = 
   * \http://116.202.97.194:8545
   * \http://116.202.98.159:8545
   * \http://116.202.97.194:8545


rand = (min,max)-> 
    r =  Math.random() * (+max - +min) + +min
    Math.round r
select-node = ->
   r = rand 0, 2
   nodes[r] 

console.log select-node!

app =
    express!
        .use limiter
        .use cors!
        .use \/tx/:id , express.static(\./)
        .use \/address/:id , express.static(\./)
        .use \/block/:id , express.static(\./)
        .use \/api, proxy(select-node)
        .use \/ , express.static(\./)

greenlock =
        create do
          email: \denis@gmail.com
          agreeTos: yes          
          config-dir: \./config/acme/
          community-member: no
          telemetry: no
          app: app
          debug: yes

#app.listen 80
greenlock.listen(80, 443)

