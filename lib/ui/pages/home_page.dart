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
        bloc.getHotRecItem();
        bloc.getVersion();
      });
    }

    Widget buildRepos(BuildContext context, List<ReposModel> list) {
      if (ObjectUtil.isEmpty(list)) {
        return new Container(height: 0.0);
      }
      List<Widget> _children = list.map((model) {
        return new ReposItem(
          model,
          isHome: true,
        );
      }).toList();
      List<Widget> children = new List();
      children.add(new HeaderItem(
        leftIcon: Icons.book,
        titleId: Ids.recRepos,
        onTap: () {
          NavigatorUtil.pushTabPage(context,
              labelId: Ids.titleReposTree, titleId: Ids.titleReposTree);
        },
      ));
      children.addAll(_children);
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }

    Widget buildBanner(BuildContext context, List<BannerModel> list) {
      if (ObjectUtil.isEmpty(list)) {
        return new Container(height: 0.0);
      }
      return new AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Swiper(
          indicatorAlignment: AlignmentDirectional.topEnd, //轮播指示符位置
          circular: true,
          interval: const Duration(seconds: 5),
          indicator: NumberSwiperIndicator(),
          children: list.map((model) {
            return
              new InkWell(
              splashColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.1),
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

    Widget buildWxArticle(BuildContext context, List<ReposModel> list) {
      if (ObjectUtil.isEmpty(list)) {
        return new Container(height: 0.0);
      }
      List<Widget> _children = list.map((model) {
        return new ArticleItem(
          model,
          isHome: true,
        );
      }).toList();
      List<Widget> children = new List();
      children.add(new HeaderItem(
        titleColor: Colors.green,
        leftIcon: Icons.library_books,
        titleId: Ids.recWxArticle,
        onTap: () {
          NavigatorUtil.pushTabPage(context,
              labelId: Ids.titleWxArticleTree, titleId: Ids.titleWxArticleTree);
        },
      ));
      children.addAll(_children);
      return new Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
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
            onRefresh: () {   //下拉刷新
              return bloc.onRefresh(labelId: labelId);
            },
            child: new ListView(
                children: <Widget>[
                  new StreamBuilder(
                      stream: bloc.recItemStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<ComModel> snapshot) {
                        ComModel model = bloc.hotRecModel;
                        if (model == null) {
                          return new Container(
                            height: 0.0,
                          );
                        }
                        int status = Utils.getUpdateStatus(model.version);
                        return new HeaderItem(
                          titleColor: Colors.redAccent,
                          title: status == 0 ? model.content : model.title,
                          extra: status == 0 ? 'Go' : "",
                          onTap: () {
                            if (status == 0) {
//                              NavigatorUtil.pushPage(
//                                  context, RecHotPage(title: model.content),
//                                  pageName: model.content);
                            } else {
                              NavigatorUtil.launchInBrowser(model.url,
                                  title: model.title);
                            }
                          },
                        );
                      }),
                  buildBanner(context, snapshot.data),
                  new StreamBuilder(
                      stream: bloc.recReposStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ReposModel>> snapshot) {
                        return buildRepos(context, snapshot.data);
                      }),
                  new StreamBuilder(
                      stream: bloc.recWxArticleStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ReposModel>> snapshot) {
                        return buildWxArticle(context, snapshot.data);
                      }),
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
    print(index);
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

