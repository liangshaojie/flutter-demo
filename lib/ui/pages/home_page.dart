import 'package:flutter/material.dart';
import 'package:my_flutter_app/common/component_index.dart';

bool isHomeInit = true;

class HomePage extends StatelessWidget {
  final String labelId;
  //接受传过来的参数
  const HomePage({Key key, this.labelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogUtil.e("HomePage build......");
    RefreshController _controller = new RefreshController();
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);
    bloc.homeEventStream.listen((event) {
      print('homeEventStream');
      if (labelId == event.labelId) {
        _controller.sendBack(false, event.status);
      }
    });

    if (isHomeInit) {
      LogUtil.e("HomePage init......");
      isHomeInit = false;
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        bloc.onRefresh(labelId: labelId);
//        bloc.getHotRecItem();
//        bloc.getVersion();
      });
    }

    Widget buildBanner(BuildContext context, List<BannerModel> list) {
      if (ObjectUtil.isEmpty(list)) {
        return new Container(height: 0.0);
      }
      return new AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Swiper(
          indicatorAlignment: AlignmentDirectional.topEnd,
          circular: true,
          interval: const Duration(seconds: 5),
          indicator: NumberSwiperIndicator(),
          children: list.map((model) {
            return new InkWell(
              onTap: () {
                LogUtil.e("BannerModel: " + model.toString());
                NavigatorUtil.pushWeb(context,
                    title: model.title, url: model.url);
              },
              child: new CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: model.imagePath,
                placeholder: (context, url) => new ProgressView(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            );
          }).toList(),
        ),
      );
    }



    return new StreamBuilder(
      stream: bloc.bannerStream,
        builder: (BuildContext context, AsyncSnapshot<List<BannerModel>> snapshot) {
          return new RefreshScaffold(
            labelId: labelId,
            isLoading: snapshot.data == null,
            controller: _controller,
            enablePullUp: false,
            onRefresh: () {
              return bloc.onRefresh(labelId: labelId);
            },
            child: new ListView(
                children: <Widget>[
                  buildBanner(context, snapshot.data),
                ]
            )
          );
        }
    );
  }
}


class NumberSwiperIndicator extends SwiperIndicator {
  @override
  Widget build(BuildContext context, int index, int itemCount) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black45, borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.only(top: 10.0, right: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      child: Text("${++index}/$itemCount",
          style: TextStyle(color: Colors.white70, fontSize: 11.0)),
    );
  }
}

