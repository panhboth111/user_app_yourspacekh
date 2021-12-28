import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text("Terms and Condition",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              SizedBox(
                height: 20,
              ),
              Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum gravida metus nibh, quis vulputate urna bibendum ut. Maecenas lectus est, mollis id erat id, condimentum iaculis sem. Duis mi ex, posuere ac ultrices vel, sagittis sed sapien. Sed quis ultricies purus. Aliquam eu lorem sollicitudin, consequat eros vitae, volutpat lectus. Vivamus sagittis justo vel mi fringilla vestibulum. Etiam in fermentum ligula. Morbi maximus bibendum interdum. Proin posuere eros vitae enim dapibus interdum. Sed dictum tortor arcu, nec euismod metus fringilla sed. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Proin eget neque ut ex viverra volutpat. Duis fringilla mattis turpis, a dapibus orci. Ut consectetur sapien purus, nec facilisis quam tristique sit amet. Maecenas lacinia a nunc sit amet luctus.",
                  style: TextStyle(fontSize: 17))
            ],
          ),
        ),
      ),
    );
  }
}
