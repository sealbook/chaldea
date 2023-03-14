import 'package:chaldea/app/battle/functions/function_executor.dart';
import 'package:chaldea/app/battle/models/battle.dart';
import 'package:chaldea/app/battle/models/svt_entity.dart';
import 'package:chaldea/models/db.dart';
import 'package:chaldea/models/gamedata/gamedata.dart';

class GainNpFromTargets {
  GainNpFromTargets._();

  static bool gainNpFromTargets(
    final BattleData battleData,
    final DataVals dataVals,
    final Iterable<BattleServantData> targets,
  ) {
    final functionRate = dataVals.Rate ?? 1000;
    if (functionRate < battleData.probabilityThreshold) {
      return false;
    }

    final BaseFunction dependFunction = db.gameData.baseFunctions[dataVals.DependFuncId!]!;
    final dependVal = dataVals.DependFuncVals!;
    final checkValue = dependVal.Value!;

    for (final receiver in targets) {
      //  denoting who should receive the absorbed np
      int gainValue = 0;
      for (final absorbTarget in FunctionExecutor.acquireFunctionTarget(
        battleData,
        dependFunction.funcTargetType,
        dependFunction.funcId,
        receiver,
      )) {
        final targetNP = absorbTarget.isPlayer ? absorbTarget.np : absorbTarget.npLineCount;
        // ignoring Value2 for enemy here as the only usage is in Yuyu (svt 275)'s skill 2
        // which has value 100 (I assume that's a percentage? But doesn't make sense)
        final baseGainValue = receiver.isEnemy ? 1 : dependVal.Value2 ?? checkValue;

        if (targetNP >= checkValue) {
          gainValue += baseGainValue;
        } else if (receiver.isPlayer && absorbTarget.isPlayer) {
          gainValue += targetNP;
        }
      }

      if (receiver.isEnemy) {
        receiver.changeNPLineCount(gainValue);
      } else {
        receiver.changeNP(gainValue);
      }
    }

    final NiceFunction niceFunction = NiceFunction(
        funcId: dependFunction.funcId,
        funcType: dependFunction.funcType,
        funcTargetType: dependFunction.funcTargetType,
        funcTargetTeam: dependFunction.funcTargetTeam,
        funcPopupText: dependFunction.funcPopupText,
        funcPopupIcon: dependFunction.funcPopupIcon,
        functvals: dependFunction.functvals,
        funcquestTvals: dependFunction.funcquestTvals,
        funcGroup: dependFunction.funcGroup,
        traitVals: dependFunction.traitVals,
        buffs: dependFunction.buffs,
        // Rate of dataVals.DependFuncVals is always 0, not sure why, so substituting functionRate into it
        svals: [
          DataVals({'Rate': functionRate, 'Value': checkValue})
        ]);

    FunctionExecutor.executeFunction(battleData, niceFunction, 1); // we provisioned only one dataVal

    return true;
  }
}
