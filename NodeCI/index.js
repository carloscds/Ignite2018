var http = require('http');

var server = http.createServer(function(request, response) {

    response.writeHead(200, {"Content-Type": "text/plain"});
    response.end("Node running VSCode at Ignite");

});

var port = process.env.PORT || 8081;
server.listen(port);


console.log("Executando em http://localhost:%d", port);
