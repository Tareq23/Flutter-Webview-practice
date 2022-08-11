

<h2>Flutter WebView with Javascript communication</h2>

```dart
Widget _buildWebView(BuildContext context)
  {
    return WebView(
      initialUrl: 'https://himdeve.com/',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController){
        _controller.complete(webViewController);
      },
      navigationDelegate: (request ) =>_buildNavigationDecision(request,context),
      onPageFinished: (url)=>_showPageTitle(),
      javascriptChannels: <JavascriptChannel>{
        _createTopBarJsChannel(),
      },
    );
  }
```


```dart
Widget _buildShowUrlBtn()
  {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder: (BuildContext context, AsyncSnapshot<WebViewController>controller ){
        if(controller.hasData){
          return FloatingActionButton(
            onPressed: ()async{
              String? url = await controller.data!.currentUrl();
              print("current url : $url");
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Current url $url'),));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Current url $url'),));
            },
            child: Icon(Icons.title),
          );
        }
        else{
          return SizedBox.shrink();
        }
      },
    );
  }
```

```dart
void _showPageTitle(){
    _controller.future.then((webViewController){
      webViewController.runJavascript(
        "TopBarJsChannel.postMessage(document.title);"
      );
    });
  }
```

```dart

JavascriptChannel _createTopBarJsChannel(){
    return JavascriptChannel(
      name: "TopBarJsChannel",
      onMessageReceived: (message){
        String newTitle = message.message;
        if(newTitle.contains("-")){
          newTitle = newTitle.substring(0,newTitle.indexOf('-')).trim();
        }
        setState((){
          _title = newTitle;
        });
      }
    );
  }
```

```dart
NavigationDecision _buildNavigationDecision(NavigationRequest request,BuildContext context)
  {

    if(request.url.contains('my-account')){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Don't have the right access to this page")));
      return NavigationDecision.prevent;
    }

    print("click Navigation button");
    return NavigationDecision.navigate;
  }
```