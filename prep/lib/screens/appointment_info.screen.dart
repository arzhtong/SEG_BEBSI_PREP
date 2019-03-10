import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class AppointmentInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppointmentInfoState();
  }
}

class _AppointmentInfoState extends State<AppointmentInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Html(
          data: """<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quis blandit turpis cursus in hac habitasse platea. Nullam non nisi est sit. Dui sapien eget mi proin sed libero enim sed faucibus. Convallis a cras semper auctor neque vitae. Diam maecenas sed enim ut sem. A condimentum vitae sapien pellentesque. Sed vulputate odio ut enim blandit. Egestas tellus rutrum tellus pellentesque eu tincidunt. Auctor augue mauris augue neque gravida in fermentum et. Id aliquet risus feugiat in ante metus dictum. Non consectetur a erat nam at lectus urna duis convallis. Morbi tristique senectus et netus et malesuada fames ac turpis. Pellentesque elit eget gravida cum sociis natoque penatibus. Curabitur gravida arcu ac tortor dignissim. Malesuada fames ac turpis egestas integer eget. Turpis egestas pretium aenean pharetra. Nisi est sit amet facilisis magna etiam tempor.</p><p><br></p><p><img src="https://firebasestorage.googleapis.com/v0/b/prep-232116.appspot.com/o/images%2Ffootball.jpg?alt=media&amp;token=1df90d67-987a-4c1d-8ff2-afc91adb5e4e"></p><p><br></p><blockquote>Velit laoreet id donec ultrices tincidunt arcu non sodales. Cras pulvinar mattis nunc sed blandit libero volutpat. Quam nulla porttitor massa id. Sed vulputate odio ut enim blandit volutpat. In hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit. Congue quisque egestas diam in arcu cursus euismod quis viverra. Eleifend donec pretium vulputate sapien nec sagittis aliquam malesuada. Porttitor leo a diam sollicitudin tempor id eu. Semper auctor neque vitae tempus quam pellentesque nec. Etiam tempor orci eu lobortis elementum nibh tellus. Arcu dui vivamus arcu felis bibendum ut tristique. Nisi scelerisque eu ultrices vitae auctor eu augue. Proin libero nunc consequat interdum varius sit amet mattis. Lacinia quis vel eros donec ac odio. Morbi blandit cursus risus at. Dictum fusce ut placerat orci nulla. Dictum varius duis at consectetur lorem donec massa.</blockquote><p><br></p><ol><li>Sit amet consectetur adipiscing elit ut aliquam purus sit amet. Lorem ipsum dolor sit amet consectetur adipiscing elit ut aliquam. Enim neque volutpat ac tincidunt vitae semper. A erat nam at lectus urna. Enim tortor at auctor urna nunc id cursus metus aliquam. Augue eget arcu dictum varius duis at. Vel pretium lectus quam id leo in vitae. Sed enim ut sem viverra. Cras pulvinar mattis nunc sed blandit libero. Ultricies mi quis hendrerit dolor magna. Est ante in nibh mauris cursus mattis molestie a iaculis.</li><li>Porttitor lacus luctus accumsan tortor posuere ac ut consequat semper. Placerat orci nulla pellentesque dignissim enim sit amet venenatis. Quam viverra orci sagittis eu volutpat odio facilisis mauris sit. Ut consequat semper viverra nam libero justo. Semper feugiat nibh sed pulvinar proin. Cum sociis natoque penatibus et magnis. Quisque egestas diam in arcu cursus euismod quis viverra. Id volutpat lacus laoreet non. Ullamcorper eget nulla facilisi etiam dignissim diam quis. Morbi quis commodo odio aenean sed adipiscing diam. Tellus in hac habitasse platea dictumst. Cursus turpis massa tincidunt dui. Laoreet sit amet cursus sit amet dictum sit amet. Rutrum quisque non tellus orci ac auctor augue.</li></ol><p><br></p><p>Lacus laoreet non curabitur gravida arcu ac tortor dignissim convallis. Sed blandit libero volutpat sed cras. Nibh tellus molestie nunc non blandit. Sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum curabitur. Libero volutpat sed cras ornare arcu dui vivamus arcu. Maecenas accumsan lacus vel facilisis. Nunc eget lorem dolor sed viverra ipsum nunc aliquet bibendum. Ante in nibh mauris cursus. Velit laoreet id donec ultrices tincidunt arcu non sodales neque. Sed egestas egestas fringilla phasellus faucibus. Sed viverra ipsum nunc aliquet. Cras semper auctor neque vitae tempus quam pellentesque nec. Ligula ullamcorper malesuada proin libero nunc consequat interdum varius. Ut tellus elementum sagittis vitae et leo duis ut. In fermentum posuere urna nec tincidunt praesent semper feugiat. Ac tortor dignissim convallis aenean et tortor at risus viverra. Cursus sit amet dictum sit amet justo donec enim. Accumsan sit amet nulla facilisi morbi. Lectus mauris ultrices eros in cursus turpis massa tincidunt dui.</p>""",
          padding: EdgeInsets.all(10.0),
          onLinkTap: (url){
            print("Opening something");
          },
          customRender: (node, children){
            if (node is dom.Element) {
              switch (node.localName) {
                case "custom_tag":
                  return Column(children: children);
              }
            }
          },
        ),
      )
    );
  }
}