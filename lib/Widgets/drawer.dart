import 'package:flutter/material.dart';
import 'package:chatllm/Animation/background_animation.dart';

class RoomDrawer extends StatelessWidget {
  final List<String> rooms;
  final String currentRoom;
  final Function(String) onNavigateToRoom;
  final Function() onAddRoom;
  final Function(String) deleteRoom;
  final Function(String) updateRoomName;

  const RoomDrawer({super.key, 
    required this.rooms,
    required this.currentRoom,
    required this.onNavigateToRoom,
    required this.onAddRoom,
    required this.deleteRoom,
    required this.updateRoomName,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black87,
      child: Stack(
        children: [
          DNA4thParticleAnimation(
              child: Container(
            color: const Color.fromARGB(200, 0, 0, 0),
          )),
          ListView(
            children: [
              SizedBox(
                height: 100,
                child: DrawerHeader(
                    child: Center(
                        child: Text('Conversation Rooms',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)))),
              ),
              ListTile(
                title: Text(
                  'Create New Room',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                onTap: onAddRoom,
                trailing: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
              ),
              ...rooms.map((room) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ListTile(
                      selectedTileColor: Colors.white10,
                      title: Text(
                        room,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => onNavigateToRoom(room),
                      selected: room == currentRoom,
                      trailing: PopupMenuButton<String>(color: Colors.black,
                        onSelected: (String result) {
                          if (result == 'edit') {
                            updateRoomName(room);
                          } else if (result == 'delete') {
                            deleteRoom(room);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit',style: TextStyle(color: Colors.blue),),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete', style: TextStyle(color: Colors.red),),
                          ),
                        ],
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                      ),
                      // trailing: IconButton(
                      //   icon: Icon(Icons.more_vert),
                      //   onPressed: () async {
                      //     await onShowRoomOptions(room);
                      //   },
                      // ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
