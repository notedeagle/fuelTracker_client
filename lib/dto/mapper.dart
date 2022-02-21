import 'package:flutter_tracker_client/dto/expense_dto.dart';
import 'package:flutter_tracker_client/dto/refuel_dto.dart';
import 'package:flutter_tracker_client/dto/view_dto.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';

class Mapper {
  Future<List<ViewDto>> getViewListByVehicleName(String vehicleName) async {
    List<ViewDto> viewList = [];

    for (RefuelDto refuel
        in await RefuelRepository().getRefuelByCarName(vehicleName)) {
      viewList.add(ViewDto.fromRefuel(refuel));
    }

    for (ExpenseDto expense
        in await ExpenseRepository().getExpenseByCarName(vehicleName)) {
      viewList.add(ViewDto.fromExpense(expense));
    }

    return viewList;
  }
}
