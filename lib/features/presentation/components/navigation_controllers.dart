

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationController extends StatelessWidget {
  final Future<WebViewController> _futureController;
  NavigationController(this._futureController,{Key? key}) : super(key: key);

  final TextStyle _textStyle = TextStyle(color: Colors.white,fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _futureController,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> controller){
        if(controller.hasData){
          return Row(
            children: [

              _buildHistoryBackBtn(context,controller),
              _buildReloadBtn(context,controller),
              _buildHistoryForwardBtn(context,controller),

            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
  Widget _buildReloadBtn(BuildContext context, AsyncSnapshot<WebViewController> controller){
    return TextButton(
      onPressed: (){
        controller.data!.reload();
      },
      child: Icon(Icons.refresh,color: Colors.white,),
    );
  }
  Widget _buildHistoryForwardBtn(BuildContext context, AsyncSnapshot<WebViewController> controller){
    return TextButton(
      onPressed: () async{
        if(await controller.data!.canGoForward()){
          controller.data!.goForward();
        }
      },
      child: Row(
        children: [
          Text('Next',style: _textStyle,),
          Icon(Icons.arrow_forward,color: Colors.white,),
        ],
      ),
    );
  }
  Widget _buildHistoryBackBtn(BuildContext context, AsyncSnapshot<WebViewController> controller){
    return TextButton(
      onPressed: () async{
        if(await controller.data!.canGoBack()){
          controller.data!.goBack();
        }
      },
      child: Row(
        children: [
          Icon(Icons.arrow_back,color: Colors.white,),
          Text('Back',style: _textStyle,)
        ],
      ),
    );
  }
}
