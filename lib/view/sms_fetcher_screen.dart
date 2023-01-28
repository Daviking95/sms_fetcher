import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../bloc/sms_fetch_bloc.dart';
import '../model/SmsResponseModel.dart';
import '../services/sms_service.dart';
import '../shared/error_popup.dart';
import '../shared/styles.dart';
import '../utils.dart';

class SmsFetcherScreen extends StatefulWidget {
  final String title;

  const SmsFetcherScreen({super.key, required this.title});

  @override
  _SmsFetcherScreenState createState() => _SmsFetcherScreenState();
}

class _SmsFetcherScreenState extends State<SmsFetcherScreen> {
  List<SmsResponseModel> smsList = [];
  List<SmsResponseModel> filteredSmsList = [];
  late SmsFetchBloc smsFetchBloc;
  double _totalSum = 0;
  double _filteredTotalSum = 0;
  final RegExp numberWithTwoDecimalPoints = RegExp(r'\d+(,\d{3})*(\.\d{2,})');
  int indexItem = -1;
  bool showMoreDetails = false;
  bool showAllMoreDetails = false;
  TextEditingController _searchController = TextEditingController();

  String _currency = "AED";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBloc();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    smsFetchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          InkWell(
            onTap: () => smsFetchBloc.add(FetchSmsButtonPressEvent()),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<SmsFetchBloc>(
            create: (context) => smsFetchBloc,
          ),
        ],
        child: BlocListener<SmsFetchBloc, SmsFetchState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is SmsFetchLoadingState) {
              AppUtils.loader = true;
              log("SmsFetchLoadingState");
            }
            if (state is SmsFetchSuccessState) {
              AppUtils.loader = false;
              smsList = [];
              filteredSmsList = [];
              _filteredTotalSum = 0;
              _totalSum = 0;
              log("SmsFetchSuccessState");

              for (var e in state.signupResponseModel) {
                // log("message ${e.state} ${e.address} ${e.kind} ${e.sender}");

                if (e.kind == SmsMessageKind.Received) {
                  double amount = 0;
                  final Match? match =
                      numberWithTwoDecimalPoints.firstMatch(e.body ?? "");
                  if (match != null) {
                    amount = double.parse(
                        match.group(0).toString().replaceAll(",", ""));

                    _totalSum = _totalSum + amount;
                  }

                  smsList.add(
                    SmsResponseModel(
                      message: e.body,
                      smsProvider: e.address,
                      amount: amount,
                      date: DateFormat('dd/MM/yyyy').format(e.date!),
                    ),
                  );
                }
              }

              setState(() {
                filteredSmsList = smsList;
                _filteredTotalSum = _totalSum;
              });
            }
            if (state is SmsFetchFailureState) {
              //TODO: Display Error Message
              AppUtils.loader = false;
              log("SmsFetchFailureState");

              smsList = [];
              filteredSmsList = [];
              errorPopUpAlert(
                  context, state.errorResponseModel.errorMessage ?? "");
              return;
            }
          },
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: AppUtils.loader
                ? Container(
                    height: MediaQuery.of(context).size.height + 200,
                    child: const CircularProgressIndicator())
                : filteredSmsList.isEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height + 200,
                        child: Center(
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Click here To Fetch SMS',
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            onPressed: () {
                              _fetchData();
                            },
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          SingleChildScrollView(
                            child: Center(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                margin: const EdgeInsets.only(top: 70),
                                height: MediaQuery.of(context).size.height,
                                child: ListView.builder(
                                  itemCount: filteredSmsList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var currentItem = filteredSmsList[index];
                                    DateTime currentDateFormatted =
                                        DateFormat('dd/MM/yyyy')
                                            .parse(currentItem.date!);
                                    DateTime prevCurrentDateFormatted = index -
                                                1 ==
                                            -1
                                        ? DateTime.now()
                                        : DateFormat('dd/MM/yyyy').parse(
                                            filteredSmsList[index - 1].date!);
                                    if (index == 0 ||
                                        currentDateFormatted.month !=
                                            prevCurrentDateFormatted.month) {
                                      return Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25, bottom: 10),
                                            child: Text(DateFormat('MMMM yyyy')
                                                .format(DateFormat('dd/MM/yyyy')
                                                    .parse(currentItem.date!))),
                                          ),
                                          _buildItem(index),
                                        ],
                                      );
                                    } else {
                                      return _buildItem(index);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: TextField(
                                onChanged: (query) => _filterList(query),
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Search',
                                  hintText: 'Search here',
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                color: Color(0xff89CFF0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total",
                                      style: textDescription.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "$_currency ${_filteredTotalSum.toStringAsFixed(2)}",
                                      style: textDescription.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  _buildItem(int i) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.only(
          top: 5, bottom: (i == filteredSmsList.length - 1) ? 250 : 5),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filteredSmsList[i].smsProvider ?? "",
                    style: textDescription.copyWith(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "$_currency ${filteredSmsList[i].amount.toString()}",
                    style:
                        textDescription.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    filteredSmsList[i].date ?? "",
                    style: textDescription.copyWith(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        indexItem = i;
                        showMoreDetails = !showMoreDetails;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Click to show",
                        style: textDescription,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if ((indexItem == i && showMoreDetails) || showAllMoreDetails)
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    filteredSmsList[i].message ?? "",
                    style: textDescription,
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  void _fetchBloc() async {
    smsFetchBloc = SmsFetchBloc(RepositoryProvider.of<SmsService>(context));

    _fetchData();
  }

  void _fetchData() async {
    smsFetchBloc.add(FetchSmsButtonPressEvent());
  }

  _filterList(String query) {
    List<SmsResponseModel> foundList = [];
    _filteredTotalSum = 0;

    if (query.isNotEmpty) {
      for (var item in smsList) {
        if ((item.smsProvider != null &&
                item.smsProvider!.toLowerCase().contains(query.toLowerCase()))
            // ||
            // (item.message != null &&
            //     item.message!.toLowerCase().contains(query.toLowerCase()))
            ) {
          foundList.add(item);
          _filteredTotalSum += item.amount ?? 0;
        }
      }

      showAllMoreDetails = true;
    } else {
      foundList = smsList;
      _filteredTotalSum = _totalSum;
      showAllMoreDetails = false;
    }

    setState(() {
      filteredSmsList = foundList;
      // _totalSum = _filteredTotalSum;
    });
  }
}
