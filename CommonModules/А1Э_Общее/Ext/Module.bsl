﻿
// Вызывает исключение если значение не соответствует переданному типу.
//
// Параметры:
//  Значение - ЛюбоеЗначение - Значение, тип которого проверяется
//  Тип		 - Тип, Строка	 - Тип, которому должно соответствовать Значение, или имя этого типа.
//  Строго	 - Булево		 - Если проверка строгая, в случае несоответствия вызывает исключение. Иначе просто возвращает ложь.
// 
// Возвращаемое значение:
//  Булево - Истина если соответствует, Ложь / Исключение если не соответствует. 
//
Функция ПроверитьТип(Значение, Знач Тип, Строго = Истина) Экспорт
	Если ТипЗнч(Тип) = Тип("Строка") Тогда
		Тип = Тип(Тип);
	КонецЕсли;
	Если ТипЗнч(Значение) <> Тип Тогда
		Если Строго Тогда
			ВызватьИсключение "Переданное значение " + Значение + " не соответствует типу " + Тип + "!";
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	Возврат Истина;
КонецФункции

// Выполняет функцию с  параметрами, возвращает результат
//
// Параметры:
//  ПолноеИмяФункции - Строка - полное имя функции  
//  П1				 - 	 - 
//  П2				 - 	 - 
//  П3				 - 	 - 
//  П4				 - 		 - 
//  П5				 - 		 - 
//  П6				 - 		 - 
//  П7				 - 		 - 
//  П8				 - 		 - 
//  П9				 - 		 - 
//  П10				 - 		 - 
// 
// Возвращаемое значение:
//   - 
//
Функция РезультатФункции(ПолноеИмяФункции, П1 = Null, П2 = Null, П3 = Null, П4 = Null, П5 = Null, П6 = Null, П7 = Null, П8 = Null, П9 = Null, П10 = Null) Экспорт 
	Попытка 
		Возврат Вычислить(СтрокаВыполнения(ПолноеИмяФункции, П1, П2, П3, П4, П5, П6, П7, П8, П9, П10));
	Исключение //Сделано чтобы срабатывала остановка по ошибке.
		ОписаниеОшибки = ОписаниеОшибки();
		А1Э_Служебный.СлужебноеИсключение("Не удалось вычислить функцию " + ПолноеИмяФункции + " по причине: " + ОписаниеОшибки);
	КонецПопытки;
КонецФункции

// Выполняет процедуру с параметрами
//
// Параметры:
//  ПолноеИмяФункции - 	 - 
//  П1				 - 	 - 
//  П2				 - 	 - 
//  П3				 - 	 - 
//  П4				 - 	 - 
//  П5				 - 	 - 
//  П6				 - 	 - 
//  П7				 - 	 - 
//  П8				 - 	 - 
//  П9				 - 	 - 
//  П10				 - 	 - 
//
Процедура РезультатПроцедуры(ПолноеИмяФункции, П1 = Null, П2 = Null, П3 = Null, П4 = Null, П5 = Null, П6 = Null, П7 = Null, П8 = Null, П9 = Null, П10 = Null) Экспорт
	Попытка
		Выполнить СтрокаВыполнения(ПолноеИмяФункции, П1, П2, П3, П4, П5, П6, П7, П8, П9, П10);
	Исключение //Сделано чтобы срабатывала остановка по ошибке.
		ОписаниеОшибки = ОписаниеОшибки();
		ВызватьИсключение ОписаниеОшибки;
	КонецПопытки;
КонецПроцедуры

Функция СтрокаВыполнения(ПолноеИмяФункции,  П1 = Null, П2 = Null, П3 = Null, П4 = Null, П5 = Null, П6 = Null, П7 = Null, П8 = Null, П9 = Null, П10 = Null) Экспорт
	СтрокаВыполнения = ПолноеИмяФункции + "(";
	Если П1 = Null Тогда Возврат СтрокаВыполнения + ")"; КонецЕсли;	СтрокаВыполнения = СтрокаВыполнения + "П1";
	Если П2 = Null Тогда Возврат СтрокаВыполнения + ")"; КонецЕсли;	СтрокаВыполнения = СтрокаВыполнения + ", П2";
	Если П3 = Null Тогда Возврат СтрокаВыполнения + ")"; КонецЕсли;	СтрокаВыполнения = СтрокаВыполнения + ", П3";
	Если П4 = Null Тогда Возврат СтрокаВыполнения + ")"; КонецЕсли;	СтрокаВыполнения = СтрокаВыполнения + ", П4";
	Если П5 = Null Тогда Возврат СтрокаВыполнения + ")"; КонецЕсли;	СтрокаВыполнения = СтрокаВыполнения + ", П5";
	Если П6 = Null Тогда Возврат СтрокаВыполнения + ")"; КонецЕсли;	СтрокаВыполнения = СтрокаВыполнения + ", П6";
	Если П7 = Null Тогда Возврат СтрокаВыполнения + ")"; КонецЕсли;	СтрокаВыполнения = СтрокаВыполнения + ", П7";
	Если П8 = Null Тогда Возврат СтрокаВыполнения + ")"; КонецЕсли;	СтрокаВыполнения = СтрокаВыполнения + ", П8";
	Если П9 = Null Тогда Возврат СтрокаВыполнения + ")"; КонецЕсли;	СтрокаВыполнения = СтрокаВыполнения + ", П9";
	Если П10 = Null Тогда Возврат СтрокаВыполнения + ")"; КонецЕсли; СтрокаВыполнения = СтрокаВыполнения + ", П10";
	Возврат СтрокаВыполнения + ")";
КонецФункции 

// Возвращает значение свойства Источника, или ЗначениеПоУмолчанию если такого свойства нет
//
// Параметры:
//  Источник			 - 	 - 
//  ИмяСвойства			 - 	 - 
//  ЗначениеПоУмолчанию	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция ЗначениеСвойства(Источник, ИмяСвойства, ЗначениеПоУмолчанию = Неопределено) Экспорт
	Если А1Э_СтандартныеТипы.Примитивный(Источник) Тогда Возврат ЗначениеПоУмолчанию; КонецЕсли;
	Структура = Новый Структура(ИмяСвойства, ЗначениеПоУмолчанию);
	ЗаполнитьЗначенияСвойств(Структура, Источник);
	Возврат Структура[ИмяСвойства];
КонецФункции

// Возвращает истина, если у Источник есть свойство, ложь если нет.
//
// Параметры:
//  Источник	 - 	 - 
//  ИмяСвойства	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция Свойство(Источник, ИмяСвойства) Экспорт
	Возврат ЗначениеСвойства(Источник, ИмяСвойства, Null) <> Null;
КонецФункции 

Функция ЗначенияСвойств(Источник, Знач Свойства, ЗначениеПоУмолчанию = Неопределено) Экспорт
	Свойства = А1Э_Массивы.Массив(Свойства);
	Результат = Новый Структура;
	Для Каждого Свойство Из Свойства Цикл
		Результат.Вставить(Свойство, ЗначениеПоУмолчанию);
	КонецЦикла;
	Если Источник = Неопределено Тогда Возврат Результат; КонецЕсли;
	ЗаполнитьЗначенияСвойств(Результат, Источник);
	Возврат Результат;
КонецФункции

// Возвращает Значение, если оно не пустое, иначе ЗначениеПоУмолчанию 
//
// Параметры:
//  Значение			 - 	 - 
//  ЗначениеПоУмолчанию	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция НепустоеЗначение(Значение, ЗначениеПоУмолчанию = Неопределено) Экспорт
	Возврат ?(ЗначениеЗаполнено(Значение), Значение, ЗначениеПоУмолчанию);
КонецФункции

// Устанавливает значение свойства у приемника. Если свойство отсутствует, ничего не происходит. 
//
// Параметры:
//  Приемник	 - 	 - произвольная структура данных, имеющая свойства.
//  ИмяСвойства	 - Строка - имя свойства.
//  Значение	 - 	 - значение, которое будет установлено.
// 
// Возвращаемое значение:
//   - 
//
Функция Установить(Приемник, ИмяСвойства, Значение) Экспорт
	Если НЕ Свойство(Приемник, ИмяСвойства) Тогда Возврат Неопределено; КонецЕсли;
	
	Приемник[ИмяСвойства] = Значение;
КонецФункции

// Возвращает Истина, если первое переданное значение равно одному из последующих.
//
// Параметры:
//  Значение - 	 - 
//  П1		 - 	 - 
//  П2		 - 	 - 
//  П3		 - 	 - 
//  П4		 - 	 - 
//  П5		 - 	 - 
//  П6		 - 	 - 
//  П7		 - 	 - 
//  П8		 - 	 - 
//  П9		 - 	 - 
//  П10		 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция РавноОдномуИз(Значение, П1, П2 = Null, П3 = Null, П4 = Null, П5 = Null, П6 = Null, П7 = Null, П8 = Null, П9 = Null, П10 = Null) Экспорт
	Массив = А1Э_Массивы.Создать(П1, П2, П3, П4, П5, П6, П7, П8, П9, П10);
	Возврат Массив.Найти(Значение) <> Неопределено; 
КонецФункции

Функция СистемнаяИнформация() Экспорт
	Возврат Новый СистемнаяИнформация;
КонецФункции

#Область Устарело

Функция ВычислитьФункцию(ПолноеИмяФункции, Параметры) Экспорт
	ПараметрыСтрока = "";
	Если Параметры <> Неопределено И Параметры.Количество() > 0 Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + "Параметры[" + Индекс + "],";
		КонецЦикла;
		ПараметрыСтрока = Сред(ПараметрыСтрока, 1, СтрДлина(ПараметрыСтрока) - 1);
	КонецЕсли;
	Возврат Вычислить(ПолноеИмяФункции + "(" + ПараметрыСтрока + ")");
КонецФункции

Функция ВыполнитьПроцедуру(ПолноеИмяФункции, Параметры) Экспорт
	ПараметрыСтрока = "";
	Если Параметры <> Неопределено И Параметры.Количество() > 0 Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + "Параметры[" + Индекс + "],";
		КонецЦикла;
		ПараметрыСтрока = Сред(ПараметрыСтрока, 1, СтрДлина(ПараметрыСтрока) - 1);
	КонецЕсли;
	Выполнить ПолноеИмяФункции + "(" + ПараметрыСтрока + ")";
КонецФункции

#КонецОбласти 

	
	
