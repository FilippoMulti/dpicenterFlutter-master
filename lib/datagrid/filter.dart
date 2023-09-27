enum MultiFilterType {
  containsText, //
  betweenDate, //viene eseguito un filtro che restituisce i dati contenuti all'interno di un range di due valori (inizio/fine). if x>=inizio && x<=fine
  selection, //selezione multipla
}

enum FilterSearchLogic { and, or }

class Filter {
  MultiFilterType filterType;
  FilterSearchLogic filterSeachLogic;
  dynamic value;
  dynamic defaultValue;
  bool? isSetted;

  Filter(
      {required this.filterType,
      required this.value,
      required this.isSetted,

      ///per definire il comportamento in caso di reset del filtro
      required this.defaultValue,
      this.filterSeachLogic = FilterSearchLogic.or});
}
