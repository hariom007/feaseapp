import 'package:flutter/material.dart';
import 'package:feaseapp/Values/AppColors.dart';

class StudentsData extends StatefulWidget {
  @override
  _StudentsDataState createState() => _StudentsDataState();
}

class _StudentsDataState extends State<StudentsData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students List'),
        actions: [
          Tooltip(
            message: 'Search Students',
            child: IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                }
            ),
          ),

        ],
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.only(top: 10,left: 5,bottom: 10,right: 5),
            child: Card(
              color: AppColors.white_00,
              elevation: 5,
              child: DataTable(
                headingRowHeight: 40,
                headingTextStyle: TextStyle(
                    fontFamily: 'Montserrat-regular',
                    fontWeight: FontWeight.bold,
                    color: AppColors.white_00
                ),
                headingRowColor: MaterialStateColor.resolveWith((states) => AppColors.appBarColorFont),
                columns:
                [
                  DataColumn(label: Text('#',
                    style: TextStyle(
                        fontFamily: 'Montserrat-regular',
                        fontWeight: FontWeight.bold
                    ),),),
                  DataColumn(label: Text('Std',
                    style: TextStyle(
                        fontFamily: 'Montserrat-regular',
                        fontWeight: FontWeight.bold
                    ),)),
                  DataColumn(label: Text('Student Name',
                    style: TextStyle(
                        fontFamily: 'Montserrat-regular',
                        fontWeight: FontWeight.bold
                    ),)),
                  DataColumn(label: Text('Father Name',
                    style: TextStyle(
                        fontFamily: 'Montserrat-regular',
                        fontWeight: FontWeight.bold
                    ),)),
                  DataColumn(label: Text('Contact Number',
                    style: TextStyle(
                        fontFamily: 'Montserrat-regular',
                        fontWeight: FontWeight.bold
                    ),)),
                  DataColumn(label: Text('Pending fee',
                    style: TextStyle(
                        fontFamily: 'Montserrat-regular',
                        fontWeight: FontWeight.bold
                    ),)),
                  DataColumn(label: Text('Collected fee',
                    style: TextStyle(
                        fontFamily: 'Montserrat-regular',
                        fontWeight: FontWeight.bold
                    ),)),
                  DataColumn(label: Text('Total fee',
                    style: TextStyle(
                        fontFamily: 'Montserrat-regular',
                        fontWeight: FontWeight.bold
                    ),)),
                ],
                rows: [
                  DataRow(
                      cells: [
                        DataCell(Text('01',),),
                        DataCell(Text('5',)),
                        DataCell(Text('Hariom Gupta')),
                        DataCell(Text('J R Gupta')),
                        DataCell(Text('7802******')),
                        DataCell(Text('5000')),
                        DataCell(Text('150000')),
                        DataCell(Text('200000')),
                      ]),
                  DataRow(
                      cells: [
                        DataCell(Text('02',),),
                        DataCell(Text('10',)),
                        DataCell(Text('Sunny Soni')),
                        DataCell(Text('K Soni')),
                        DataCell(Text('97262******')),
                        DataCell(Text('10000')),
                        DataCell(Text('150000')),
                        DataCell(Text('250000')),
                      ]),
                  DataRow(
                      cells: [
                        DataCell(Text('03',),),
                        DataCell(Text('9',)),
                        DataCell(Text('Ankit Mandal')),
                        DataCell(Text('Mr. Mandal')),
                        DataCell(Text('7802******')),
                        DataCell(Text('7000')),
                        DataCell(Text('150000')),
                        DataCell(Text('220000')),
                      ]),
                  DataRow(
                      cells: [
                        DataCell(Text('04',),),
                        DataCell(Text('6',)),
                        DataCell(Text('Rohan Vaja')),
                        DataCell(Text('Mr. Vaja')),
                        DataCell(Text('98792******')),
                        DataCell(Text('5000')),
                        DataCell(Text('150000')),
                        DataCell(Text('200000')),
                      ]),
                  DataRow(
                      cells: [
                        DataCell(Text('05',),),
                        DataCell(Text('5',)),
                        DataCell(Text('Hariom Gupta')),
                        DataCell(Text('J R Gupta')),
                        DataCell(Text('7802******')),
                        DataCell(Text('5000')),
                        DataCell(Text('150000')),
                        DataCell(Text('200000')),
                      ]),
                ],
              ),
            ),
          )
      ),
    );
  }
}
