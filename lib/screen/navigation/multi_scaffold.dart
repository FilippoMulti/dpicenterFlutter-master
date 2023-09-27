import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/screen/widgets/drawer_multi.dart';
import 'package:flutter/material.dart';

class MultiScaffold extends StatefulWidget {
  const MultiScaffold({Key? key, required this.menu, required this.main})
      : super(key: key);

  final Widget menu;
  final Widget main;

  @override
  MultiScaffoldState createState() => MultiScaffoldState();
}

class MultiScaffoldState extends State<MultiScaffold>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //GlobalKey containerKey = GlobalKey();
  Menu? selectedMenu;

  final GlobalKey<SliderMenuContainerExState> _sliderKey =
      GlobalKey<SliderMenuContainerExState>();

  toggle() {
    _sliderKey.currentState?.toggle();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return contentPage(widget.menu, widget.main);
  }

  /* ///da utilizzare per generare il menu dai submenus
  Widget getMenu(Menu menu){
    return Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0), child:
    Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(0),bottomRight: Radius.circular(20)), color: Theme.of(context).colorScheme.surface),
        child:
        SingleChildScrollView(
            child:
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),child:
            Column(
                children: List.generate(menu.subMenus!.length,
                        (index) => contentPageDrawerItem(menu.subMenus![index]))),
            ))),
    );
  }*/

  Widget contentPage(Widget menu, Widget main) {
//    return Icon(menu.icon);

    //if ((menu.subMenus?.length ?? 0) > 0) {

/*      WidgetsBinding.instance!
          .addPostFrameCallback((_) =>  _slideKeys![index].currentState?.openDrawer());*/

    return SliderMenuContainerEx(
      sliderMenuOpenSize: 160,
      appBarHeight: 0,
      hasAppBar: false,
      appBarColor: Colors.white,
      key: _sliderKey,
      sliderMenu: menu,
      sliderMain: main,
    );
    /*selectedMenu!= null ?
          Builder(
            builder: (BuildContext context){
              //_sliderKey.currentState!.openDrawer();
              return _buildGridTileContent(selectedMenu!);//getMenuContent(menu);// getMenuContent(selectedMenu!);
            },
          ) :

          Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child:


          _buildGrid(menu, menu.text)));
*/

    /* return
        SlideDrawer(
          key: _slideKeys?[index],
            offsetFromRight: MediaQuery.of(context).size.width-120,
          isRotate: false,
          contentDrawer: Container(
            width: 120,
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
                children: List.generate(menu.subMenus!.length,
                        (index) => contentPageDrawerItem(menu.subMenus![index])))),

          child: selectedMenu!= null ? getMenuContent(selectedMenu!) : Container(child:Center(child:Text("Benvenuto!")))
        );*/
    /*    Container(

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedContainer(
                      width: _drawerWidth ?? 140,
                      duration: Duration(milliseconds: 350),
                      child: Column(
                          children: List.generate(menu.subMenus!.length,
                                  (index) => contentPageDrawerItem(menu.subMenus![index])))),
                  selectedMenu!= null ? Expanded(child: getMenuContent(selectedMenu!)) : Expanded(child:Container(child:Center(child:Text("Benvenuto!"))))
                ],
              ));*/

    /*return Container(

          child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedContainer(
              width: _drawerWidth ?? 140,
              duration: Duration(milliseconds: 350),
              child: Column(
                  children: List.generate(menu.subMenus!.length,
                      (index) => contentPageDrawerItem(menu.subMenus![index])))),
          selectedMenu!= null ? Expanded(child: getMenuContent(selectedMenu!)) : Expanded(child:Container(child:Center(child:Text("Benvenuto!"))))
        ],
      ));*/
    /*} else {
      return Container(

          color: Colors.red,
          child: Center(
              child: Text("Pagina vuota, probabilmente si tratta di un comando")));
    }*/
  }

  /*Widget _buildGrid(Menu menu, String key) {
    int crossAxisCount = getCrossAxisCount(context);

    return AnimationLimiter(
        key: ValueKey(key),
        child: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
            crossAxisCount: crossAxisCount,
            // Generate 100 widgets that display their index in the List.
            padding: dashBoardMenu!=null && dashBoardMenu!.subMenus!.length > 0 ? EdgeInsets.symmetric(horizontal: 8) : EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            childAspectRatio: (1 / .35),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: _buildGridTileList(menu, crossAxisCount)));
  }*/
  /*Widget _buildGridContent(Menu menu, String key) {
    int crossAxisCount = 1;

    return
      Container(
          color: Colors.black87,
      child:

      AnimationLimiter(
        key: ValueKey(key),
        child:
        Column(
        children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                  child: FadeInAnimation(
                  child: widget,
                ),
              ),
    children: [getMenuContent(menu)]),
    )));

        */ /*Column(

          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
            crossAxisCount: crossAxisCount,
            // Generate 100 widgets that display their index in the List.
            //padding: dashBoardMenu!=null && dashBoardMenu!.subMenus!.length > 0 ? EdgeInsets.symmetric(horizontal: 8) : EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: _buildGridTileContentList(menu, crossAxisCount))));*/ /*
  }*/
/*
  _menuClick(Menu menu) {
    ///è un comando
    if (menu.command != null) {
      menu.command!.call();
      return;
    }

    ///è una destinazione
    if (menu.destination != null) {
      Navigator.pushNamed(context, menu.destination!, arguments: menu);
    } else {
      if (menu.subMenus != null) {
        ///carico i sottomenu
        //backTrackMenu.add(currentMenu!);
        currentMenu = menu;
        //searchBar!.cancelSearch(false, context);

        ///per riattivare l'ascolto delle scorciatoie
        //searchShortcutsFocus.requestFocus();

        */
/*        setState((){
              searchBar!.cancelSearch(context);
            });*/ /*


        ///invece di chiamare setState utilizzo l'evento clear di Search cosi nel caso sia attiva una ricerca venga cancellata e vengano caricati i sottomenu del menu selezionato
        var bloc = BlocProvider.of<NavigationScreenBloc>(context);
        bloc.add(NavigationScreenEvent(
            status: NavigatorScreenEvents.idle, param: null));
      } else {
        if (menu.type == MenuType.action) {
          //menu.onPressed!.call();
          return;
        } else {
          ///non ci sono sottomenu, non ci sono destinazioni, non ci sono azioni, mostro un errore
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                    appBar: AppBar(title: Text("Error")),
                    body: Center(child: Text("Route non definita"))),
              ));
        }
      }
    }
  }

*/

  /*///Restituisce l'item da visualizzare e definisce il callback della selezione in base al tipo di menu
  Widget getListItem(Menu menu, double fontSize, double iconSize) {
    return Hero(
        tag: menu.text + 'Hero',
        child: Material(
            type: MaterialType.transparency,
            child: Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: menu.color,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),

                  onPressed: () {
                    if (menu.destination!=null){
                      setState(() {
                          selectedMenu = menu;
                      });
                    } else {
                      menu.command?.call();
                    }
                    //_menuClick(menu);
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //Center Column contents vertically,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          menu.icon,
                          size: iconSize,
                        ),
                        Expanded(
                          child: Text(
                            menu.text,
                            style: TextStyle(
                              fontSize: fontSize,
                              overflow: TextOverflow.clip,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                ))));
  }*/
  /*Widget _buildGridTileContent(Menu menu) {
    return
      Container(
        key: containerKey,
        color: Theme.of(context).scaffoldBackgroundColor,
        child:

        List.generate(1, (int i) {
      return AnimationConfiguration.synchronized(

        duration: const Duration(milliseconds: 375),
        child: ScaleAnimation(
          child: FadeInAnimation(
              child: getMenuContent(menu)),
        ),
      );
    }).first);
  }
  Widget contentPageDrawerItem(Menu menu) {
    return
      Center(

          child:
          SizedBox(
              height: 80,
              child:
              Padding(padding:EdgeInsets.symmetric(horizontal: 4),child:
              TextButton(

                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      //side: BorderSide(color: Color.fromARGB(255, 197, 197, 246), width: 0.1)
                      ),
                  onPressed: () {

                      setState(() {
                        selectedMenu = menu;
                      });

                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(child:
                      Icon(menu.icon, color: menu.color,)),
                      SizedBox(height: 16,),

                      Center(
                        child:
                        Text(menu.text,textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge,),
                      )

                    ],
                  )))));
  }*/

/*
  Widget getMenuContent(Menu menu) {
    ///è un comando
    if (menu.command != null) {
      menu.command!.call();
      return Text("Comando eseguito");
    }

    ///è una destinazione
    if (menu.destination != null) {

      //Display Main Screen
      return DpiCenterApp.of(context)!.getScreen(menu.destination!, menu, (){
        setState(() {
          ///rivisualizzo il menu
           selectedMenu = null;
        });
      });

    } else {
      switch(menu.type){
        case MenuType.action:
          return Text("Action");
        case MenuType.dashboard:

        default:
          break;
      }
      if (menu.type == MenuType.action) {
        //menu.onPressed!.call();
        return Text("Action");
      } else {
        ///non ci sono sottomenu, non ci sono destinazioni, non ci sono azioni, mostro un errore
       */
/* WidgetsBinding.instance!
            .addPostFrameCallback((_) =>  Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                  appBar: AppBar(title: Text("Error")),
                  body: Center(child: Text("Route non definita"))),
            )));*/ /*


      }
    }
    return Container(color: Colors.red, child:Center(child:Text("Comando non ancora implementato\r\n:(", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall,)));

  }
*/

  @override
  bool get wantKeepAlive => true;
}
