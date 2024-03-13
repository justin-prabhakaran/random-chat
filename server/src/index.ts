import { Server, Socket } from "socket.io"
import http from "http"
import express from "express"
import { clearInterval } from "timers";


const server = http.createServer(express());
const io = new Server(server);



let users: Map<string, Socket> = new Map();

let connections: Map<string, string> = new Map();

async function getUser(from: Socket) {
    return new Promise<Socket>(
        (resolve) => {
            if (users.size > 1) {
                for (const [userId, userSoc] of users) {
                    if (userId !== from.id) {
                        resolve(userSoc);
                    }
                }
            }
            else {
                const id = setInterval(() => {
                    if (users.size > 1) {
                        for (const [userId, userSoc] of users) {
                            if (userId !== from.id) {
                                resolve(userSoc);
                                clearInterval(id);
                            }
                        }
                    }
                }, 2000);
            }
        }
    );
}

io.on('connection', (socket) => {
    socket.emit('connectonEvent', `your id ${socket.id}`);


    socket.on('make', async () => {
        users.set(socket.id, socket);

        let to = await getUser(socket);

        connections.set(socket.id, to.id);
        connections.set(to.id, socket.id);
        socket.emit('userConnected', `connected with ${to.id}`);
        to.emit('userConnected', `connected with ${socket.id}`);


        users.delete(socket.id);
        users.delete(to.id);


        socket.on('message', (data) => {
            to.emit('message', data);
        });

        to.on('message', (data) => {
            socket.emit('message', data);
        });
    });

    socket.on('disconnect', () => {
        console.log('Disconnected');
        const touserId = connections.get(socket.id);
        if (touserId) {
            const toUser = io.sockets.sockets.get(touserId);
            if (toUser) {
                toUser.emit('userDisconnected', `User ${socket.id} is diconnected`);
                connections.delete(socket.id);
                connections.delete(toUser.id);
            } else {
                console.log('Socket not found!');
            }

        }
        else {
            console.log('id not found');
        }
        users.delete(socket.id);
    });

    socket.onAnyOutgoing((event, args) => {
        console.log('Users : ');
        let i = 0;
        for (const [userId,] of users) {
            console.log(`${i} | ${userId}`);
            i++;
        }
        console.log('Connection : ');
        for (const [fromId, toId] of connections) {
            console.log(`${fromId} ---> ${toId}`);
        }
        console.log(`${event} | ${args}`);
    });


    socket.onAny((event, args) => {
        console.log('Users : ');
        let i = 0;
        for (const [userId,] of users) {
            console.log(`${i} | ${userId}`);
            i++;
        }
        console.log('Connection : ');
        for (const [fromId, toId] of connections) {
            console.log(`${fromId} ---> ${toId}`);
        }
        console.log(`${event} | ${args}`);
    });
});

server.listen(3000, () => {
    console.log('SERVER STARTED');
});


// var users: Array<Socket> = [];

// async function getUsers(from: Socket) {
//     return new Promise<Socket>((resolve) => {
//         if (users.length > 1) {
//             const user = users.find((user) => user.id !== from.id);
//             if (user) {
//                 resolve(user);
//             }
//         } else {
//             const id = setInterval(() => {
//                 if (users.length > 1) {
//                     const user = users.find((user) => user.id !== from.id);
//                     if (user) {
//                         clearInterval(id);
//                         resolve(user);
//                     }
//                 }
//             }, 2000);
//         }
//     });
// }


// io.on('connection', (socket) => {
//     socket.emit('connecsuc', `your id ${socket.id}`);

//     socket.on('make', async () => {
//         users.push(socket);
//         let to = await getUsers(socket);
//         socket.emit('connecsuc', `connected with ${to!.id}`);
//         to?.emit('connecsuc', `connected with ${socket.id}`)
//         users = users.filter(user => user.id !== socket.id && user.id !== to?.id);

//         socket.on('message', (data) => {
//             to!.emit('message', data);
//         });

//         to?.on('message', (data) => {
//             socket.emit('message', data);
//         });




//         socket.on('disconnect', () => {
//             console.log('Disconnected');
//             to?.emit('connecsuc', `disconnected with ${socket.id}`);
//             users = users.filter(user => user.id !== socket.id);
//         });
//     });


//     socket.onAny((event, args) => {
//         console.log('Users : ');
//         users.map(e => {
//             console.log(e.id);
//         });
//         console.log(`${event} | ${args}`);


//     })

// });

// server.listen(3000, () => {
//     console.log('SERVER STARTED');
// });