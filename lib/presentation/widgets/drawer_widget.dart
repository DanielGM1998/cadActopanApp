import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Drawer(
      //backgroundColor: Colors.black54,
      backgroundColor: Colors.blue.withOpacity(0.7),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(55, 171, 204, 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/logo_drawer.png",
                  height: 65,
                  width: 65,
                ),
                const SizedBox(height: 15),
                const Text("CAD Actopan v.1.0.1",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          ),
          DrawerListTile(
            title: "Actividad del día",
            icon: Icons.monetization_on,
            iconColor: Colors.black,
            press: () {
              /* Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ActividadDiaPage())); */
            },
          ),
          DrawerListTile(
            title: "Tareas",
            icon: Icons.task,
            iconColor: Colors.black,
            press: () {},
          ),
          DrawerListTile(
            title: "Documentos",
            icon: Icons.folder,
            iconColor: Colors.black,
            press: () {},
          ),
          DrawerListTile(
            title: "Tienda",
            icon: Icons.store,
            iconColor: Colors.black,
            press: () {},
          ),
          DrawerListTile(
            title: "Notificaciones",
            icon: Icons.notifications,
            iconColor: Colors.black,
            press: () {},
          ),
          DrawerListTile(
            title: "Perfil",
            icon: Icons.person,
            iconColor: Colors.black,
            press: () {},
          ),
          DrawerListTile(
            title: "Configuraciones",
            icon: Icons.settings,
            iconColor: Colors.black,
            press: () {},
          ),
          SizedBox(
            height: (queryData.size.height / 5),
            width: double.infinity,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Text("v1.0.1", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
