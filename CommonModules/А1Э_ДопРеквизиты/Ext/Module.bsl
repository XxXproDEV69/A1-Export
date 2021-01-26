﻿// Получает значение дополнительного реквизита по его программному имени. 
//
// Параметры:
//  Ссылка	 - ЛюбаяСсылка - должен иметь таблицу ДополнительныеРеквизиты иначе будет ошибка 
//  Имя		 - Строка - имя дополнительного реквизита (в подвале формы, в разделе "Для разработчиков")
//  ВидРеквизита - Строка, Булево - вид дополнительного реквизита. Поддерживается
//		"ДР", Ложь - допреквизит, 
//		"ДС", Истина - допсведение, 
//		"А1" - данные регистра А1_Реквизиты.
//		"А1П" - данные регистра А1_ПериодическиеРеквизиты.
//		"А1Д" - данные регистра А1Д_ДопПоля.
//   Контекст - Структура - прочие параметры, которые варьируются в зависимости от вида реквизита. Может иметь ключи:
//		"Дата" - дата (для периодических реквизитов).
//
// Возвращаемое значение:
//  ЛюбоеЗначение - значение допреквизита. Если он никогда не был задан, возвращает Неопределено. 
//
Функция Значение(Ссылка, Имя, Знач ВидРеквизита = "ДР", ЗначениеПоУмолчанию = Неопределено, Контекст = Неопределено) Экспорт
	Если Ссылка = Неопределено Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	ВидРеквизита = ВидРеквизитаПолучить(ВидРеквизита);
	
	ИменаРеквизитов = А1Э_Массивы.Массив(Имя);		
	Если ИменаРеквизитов.Количество() > 1 Тогда
		А1Э_Служебный.СлужебноеИсключение("Ожидается единственное имя допреквизита!");
	КонецЕсли;
	
	Если А1Э_СтандартныеТипы.ЭтоСсылка(Ссылка) Тогда
		Результат = ОпределениеЗначений(Ссылка, ИменаРеквизитов, ВидРеквизита, Контекст);
	Иначе //Ссылка - это объект или объект формы (ДанныеФормыСтруктура)
		Если ВидРеквизита = "ДР" Тогда
			Свойство = Свойство(Имя);
			Для Каждого Строка Из Ссылка.ДополнительныеРеквизиты Цикл
				Если Строка.Свойство = Свойство Тогда
					Возврат Строка.Значение;
				КонецЕсли;
			КонецЦикла;
			Возврат ЗначениеПоУмолчанию;
		Иначе
			Результат = ОпределениеЗначений(Ссылка.Ссылка, ИменаРеквизитов, ВидРеквизита, Контекст);
		КонецЕсли;
	КонецЕсли;
	
	
	Если Результат.Пустой() Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Если ВидРеквизита = "А1Д" Тогда
		Если ЗначениеЗаполнено(Выборка.ЗначениеСсылка) Тогда
			Возврат А1Э_Метаданные.СсылкаПоИдентификатору(Выборка.ЗначениеСсылка);
		Иначе
			Возврат Выборка.ЗначениеПримитив;
		КонецЕсли;
	Иначе
		Возврат Выборка.Значение;
	КонецЕсли;
КонецФункции 		

Функция Значения(Ссылка, Знач Имена, УбиратьПрефиксы = Истина, Знач ВидРеквизита = Ложь, ЗначениеПоУмолчанию = Неопределено, Контекст = Неопределено) Экспорт 
	ВидРеквизита = ВидРеквизитаПолучить(ВидРеквизита);
	Имена = А1Э_Массивы.Массив(Имена);	
	Результат = ОпределениеЗначений(Ссылка, Имена, ВидРеквизита, Контекст);
	
	Выборка = Результат.Выбрать();
	
	Структура = Новый Структура;
	Для Каждого Имя Из Имена Цикл
		Структура.Вставить(Имя, ЗначениеПоУмолчанию);
	КонецЦикла;
	
	Пока Выборка.Следующий() Цикл
		Структура.Вставить(Выборка.Имя, Выборка.Значение);
	КонецЦикла;
	
	Если НЕ УбиратьПрефиксы Тогда
		Возврат Структура;
	КонецЕсли;
	
	ИтоговаяСтруктура = Новый Структура;
	
	Для Каждого Пара Из Структура Цикл
		Положение = СтрНайти(Пара.Ключ, "__");
		Если Положение > 0 Тогда
			ИтоговаяСтруктура.Вставить(Сред(Пара.Ключ, Положение + 2), Пара.Значение);
		Иначе
			ИтоговаяСтруктура.Вставить(А1Э_Строки.После(Пара.Ключ, "_"), Пара.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИтоговаяСтруктура;
КонецФункции

Функция ЗначениеСсылок(Знач Ссылки, Имя, Знач ВидРеквизита = "ДР", ЗначениеПоУмолчанию = Неопределено, Контекст = Неопределено) Экспорт
	Ссылки = А1Э_Массивы.Массив(Ссылки);
	Имена = А1Э_Массивы.Массив(Имя);
	ВидРеквизита = ВидРеквизитаПолучить(ВидРеквизита);
	Результат = ОпределениеЗначений(Ссылки, Имена, ВидРеквизита, Контекст);
	Выборка = Результат.Выбрать();
	Соответствие = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		Соответствие.Вставить(Выборка.Ссылка, Выборка.Значение);
	КонецЦикла;
	Для Каждого Ссылка Из Ссылки Цикл
		Если Соответствие[Ссылка] = Неопределено Тогда
			Соответствие.Вставить(Ссылка, ЗначениеПоУмолчанию);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Соответствие;
КонецФункции 

// Получает ссылку по значению дополнительного реквизита. Если находит несколько ссылок может вернуть любую. 
//
// Параметры:
//  ИмяТипаИлиТип	 - Тип, Строка - имя справочника/документа или Тип ему соответствующий 
//  Имя				 - Строка - имя дополнительного реквизита (в подвале формы, в разделе "Для разработчиков")
//  Значение		 - ЛюбаяСсылка, Дата, Строка, Число, Булево - значение дополнительного реквизита
// 
// Возвращаемое значение:
//  ЛюбаяСсылка - ссылка на элемент соответствующего справочника/документа. 
//
Функция ЭлементПоЗначению(ИмяТипаИлиТип, Имя, Значение, Знач ВидРеквизита = "ДР") Экспорт
	Если ТипЗнч(ИмяТипаИлиТип) = Тип("Тип") Тогда
		ТипОбъекта = ИмяТипаИлиТип;
	ИначеЕсли ТипЗнч(ИмяТипаИлиТип) = Тип("Строка") Тогда
		ТипОбъекта = Тип(ИмяТипаИлиТип);
	Иначе
		ВызватьИсключение "Параметр ""ИмяТипаИлиТип"" неверного типа!";
	КонецЕсли;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаОпределенияОбъектовПоЗначению(ВидРеквизита, ТипОбъекта);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВЫБРАТЬ", "ВЫБРАТЬ ПЕРВЫЕ 1");
	
	Запрос.УстановитьПараметр("Ключи", Значение); 
	Запрос.УстановитьПараметр("Имя", Имя);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Значение, Неопределено);
	
КонецФункции

// Программно устанавливает значение определенного дополнительного реквизита у объекта
//
// Параметры:
//  Объект	 - ЛюбойОбъект	 - объект справочника/документа. Должен иметь таблицу ДополнительныеРеквизиты с колонками Свойство и Значение.
//  Имя		 - Строка - имя дополнительного реквизита (в подвале формы, в разделе "Для разработчиков")   
//  Значение - ЛюбаяСсылка, Дата, Строка, Число, Булево - значение дополнительного реквизита. 
// 
// Возвращаемое значение:
//   - 
//
Функция Установить(Объект, Имя, Значение, Знач ВидРеквизита = "ДР") Экспорт
	//ТУДУ: Сделать так, чтобы при попытке записи ДопСведения на пустую ссылку вызывалось исключение.
	
	ВидРеквизита = ВидРеквизитаПолучить(ВидРеквизита);
	
	Если ВидРеквизита = "А1" 
		ИЛИ ВидРеквизита = "А1Д" 
		Тогда
		Свойство = Имя;
	Иначе
		Свойство = Свойство(Имя);
		Если Свойство = Неопределено Тогда
			Если ВидРеквизита = "ДС" Тогда
				Текст = "Не найдено дополнительное сведение";
			Иначе
				Текст = "Не найден дополнительный реквизит";
			КонецЕсли;
			ВызватьИсключение Текст + " <" + Имя + "> при попытке установить его значение!";
		КонецЕсли;
	КонецЕсли;
	Если ВидРеквизита = "ДР" Тогда
		Для Каждого Строка Из Объект.ДополнительныеРеквизиты Цикл
			Если Строка.Свойство = Свойство Тогда
				Строка.Значение = Значение;
				Если ТипЗнч(Значение) = Тип("Строка") Тогда
					Строка.ТекстоваяСтрока = Значение;
				КонецЕсли;
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
		Строка = Объект.ДополнительныеРеквизиты.Добавить();
		Строка.Свойство = Свойство;
		Строка.Значение = Значение;
		Если ТипЗнч(Значение) = Тип("Строка") Тогда
			Строка.ТекстоваяСтрока = Значение;
		КонецЕсли;
		Возврат Истина;
	Иначе
		Если ВидРеквизита = "ДС" Тогда
			МенеджерЗаписи = РегистрыСведений["ДополнительныеСведения"].СоздатьМенеджерЗаписи();
		ИначеЕсли ВидРеквизита = "А1" Тогда
			МенеджерЗаписи = РегистрыСведений["А1_Реквизиты"].СоздатьМенеджерЗаписи();
		ИначеЕсли ВидРеквизита = "А1Д" Тогда
			МенеджерЗаписи = РегистрыСведений["А1Д_ДопПоля"].СоздатьМенеджерЗаписи();
		КонецЕсли;
		МенеджерЗаписи.Свойство = Свойство;
		Если ВидРеквизита = "А1Д" Тогда
			МенеджерЗаписи.Объект = А1Э_Метаданные.ИдентификаторПоСсылке(Объект.Ссылка);
			Если А1Э_СтандартныеТипы.Примитивный(Значение) Тогда
				МенеджерЗаписи.Примитив = Значение;
			Иначе
				МенеджерЗаписи.Ссылка = А1Э_Метаданные.ИдентификаторПоСсылке(Значение);
			КонецЕсли;
		Иначе
			МенеджерЗаписи.Объект = Объект.Ссылка;
			МенеджерЗаписи.Значение = Значение;
		КонецЕсли;
		МенеджерЗаписи.Записать(Истина);
	КонецЕсли;
	
КонецФункции

// Функция - Свойство
//
// Параметры:
//  Имя		 - Строка -  имя дополнительного реквизита (в подвале формы, в разделе "Для разработчиков")
// 
// Возвращаемое значение:
//  ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения - ссылка на свойство по его имени
//
Функция Свойство(Имя, ПовтИсп = Истина) Экспорт
	Если ПовтИсп Тогда Возврат А1Э_ПовторноеИспользование.РезультатФункции(ИмяМодуля() + ".Свойство", Имя, Ложь); КонецЕсли;
		
	Запрос = Новый Запрос( 
	"ВЫБРАТЬ
	|	ДопРеквизиты.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК ДопРеквизиты
	|ГДЕ
	|	ДопРеквизиты.Имя = &Имя");
	Запрос.УстановитьПараметр("Имя", Имя);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() > 1 Тогда
		ВызватьИсключение "Найдено более одного допреквизита по запросу <Имя>=" + Имя;
	КонецЕсли;
	Если НЕ Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат Выборка.Ссылка;
КонецФункции

Функция Удалить(Объект, Имя) Экспорт
	Свойство = Свойство(Имя);
	Если Свойство = Неопределено Тогда
		ВызватьИсключение "Не найден допреквизит <" + Имя + "> при попытке установить его значение!";
	КонецЕсли;
	Для Каждого Строка Из Объект.ДополнительныеРеквизиты Цикл
		Если Строка.Свойство = Свойство Тогда
			Объект.ДополнительныеРеквизиты.Удалить(Строка.НомерСтроки - 1);
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
КонецФункции

#Область ПроверкаСуществованияРеквизитов

Функция ПроверитьСуществованиеСлужебныхДопРеквизитов() Экспорт
	ТаблицаИмен = ТаблицаИмен();
	Если ТаблицаИмен.Количество() = 0 Тогда Возврат Неопределено КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаИмен.Имя КАК Имя
	|ПОМЕСТИТЬ ТаблицаИмен
	|ИЗ
	|	&ТаблицаИмен КАК ТаблицаИмен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаИмен.Имя КАК Имя,
	|	ЕСТЬNULL(ДополнительныеРеквизиты.Ссылка, НЕОПРЕДЕЛЕНО) КАК ДополнительныйРеквизит
	|ИЗ
	|	ТаблицаИмен КАК ТаблицаИмен
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК ДополнительныеРеквизиты
	|		ПО ТаблицаИмен.Имя = ДополнительныеРеквизиты.Имя";
	Запрос.УстановитьПараметр("ТаблицаИмен", ТаблицаИмен); 
	Выборка = Запрос.Выполнить().Выбрать();
	МассивСообщений = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Если Выборка.ДополнительныйРеквизит <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		МассивСообщений.Добавить("Для корректной работы программы необходимо создать дополнительный реквизит с именем <" + Выборка.Имя + ">!");
	КонецЦикла;
	Если МассивСообщений.Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	Сообщить("Отсутствуют ключевые дополнительные реквизиты, необходимые для работы программы!");
	Для Каждого Сообщение Из МассивСообщений Цикл
		Сообщить(Сообщение);
	КонецЦикла;
	Возврат Ложь;
КонецФункции

Функция ДобавитьИмя(ТаблицаИмен, Имя) Экспорт 
	Строка = ТаблицаИмен.Добавить();
	Строка.Имя = Имя;
КонецФункции

Функция ТаблицаИмен() 
	ТаблицаИмен = Новый ТаблицаЗначений;
	ТаблицаИмен.Колонки.Добавить("Имя", А1Э_Строки.Описание(100));
	Если Метаданные.ОбщиеМодули.Найти("А1_ИменаДопРеквизитов") = Неопределено Тогда
		Возврат ТаблицаИмен;
	КонецЕсли;
	
	Попытка
		Выполнить("А1_ИменаДопРеквизитов.ДобавитьИмена(ТаблицаИмен);");
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
	КонецПопытки;
	
	Возврат ТаблицаИмен;
КонецФункции

#КонецОбласти 

#Область Служебно

Функция ОпределениеЗначений(Знач Ссылки, ИменаРеквизитов, Знач ВидРеквизита, Контекст = Неопределено)
	Ссылки = А1Э_Массивы.Массив(Ссылки);
	ВидРеквизита = ВидРеквизитаПолучить(ВидРеквизита);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДопРеквизиты.Ссылка КАК Ссылка,
	|	ДопРеквизиты.Свойство.Имя КАК Имя,
	|	ДопРеквизиты.Значение КАК Значение
	|ИЗ
	|	&ИмяТаблицы КАК ДопРеквизиты
	|ГДЕ
	|	ДопРеквизиты.Ссылка В(&Ссылки)
	|	И ДопРеквизиты.Свойство.Имя В(&Имена)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Имя";
	ТипОбъектов = ТипЗнч(Ссылки[0]);
	ОбработатьТекстЗапросаПоВидуРеквизита(Запрос.Текст, ВидРеквизита, ТипОбъектов);
	Если ВидРеквизита = "А1Д" Тогда
		Идентификаторы = Новый Массив;
		Для Каждого Ссылка Из Ссылки Цикл
			Идентификаторы.Добавить(А1Э_Метаданные.ИдентификаторПоСсылке(Ссылка));
		КонецЦикла;
		Запрос.УстановитьПараметр("Ссылки", Идентификаторы);
	Иначе
		Запрос.УстановитьПараметр("Ссылки", Ссылки);
	КонецЕсли;
	Если ВидРеквизита = "А1П" Тогда
		ВыполнитьДействияДляПолученияПериодическихРеквизитов(Запрос, ИменаРеквизитов, Контекст);
	Иначе
		Запрос.УстановитьПараметр("Имена", ИменаРеквизитов);
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Возврат Результат;
КонецФункции 

Функция ВидРеквизитаПолучить(ВидРеквизита)
	Если ТипЗнч(ВидРеквизита) = Тип("Строка") Тогда
		Врег = ВРЕГ(ВидРеквизита);
		Если НЕ (Врег = "ДС" Или Врег = "ДР" Или Врег = "А1" Или Врег = "А1П" Или Врег = "А1Д") Тогда
			А1Э_Служебный.СлужебноеИсключение("Неверный вид реквизита - ожидается ""ДС"", ""ДР"", ""А1"" или ""А1Д""");
		КонецЕсли;
		Возврат Врег;
	ИначеЕсли ВидРеквизита = Истина Тогда
		Возврат "ДС";
	ИначеЕсли ВидРеквизита = Ложь Тогда
		Возврат "ДР";
	Иначе
		А1Э_Служебный.ИсключениеНеверныйТип("ВидРеквизита", "А1Э_ДопРеквизиты.ВидРеквизита", ВидРеквизита, "Строка,Булево");
	КонецЕсли;
КонецФункции

Функция ТекстЗапросаОпределенияОбъектовПоЗначению(Знач ВидРеквизита = "ДР", ТипОбъектов = Неопределено) Экспорт 
	ВидРеквизита = ВидРеквизитаПолучить(ВидРеквизита);
	Текст = 
	"ВЫБРАТЬ
	|	ДопРеквизиты.Значение КАК Ключ,
	|	ДопРеквизиты.Ссылка КАК Значение
	|ИЗ
	|	&ИмяТаблицы КАК ДопРеквизиты
	|ГДЕ
	|	ДопРеквизиты.Значение В (&Ключи)
	|	И ДопРеквизиты.Свойство.Имя = &Имя
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДопРеквизиты.Ссылка";
	ОбработатьТекстЗапросаПоВидуРеквизита(Текст, ВидРеквизита, ТипОбъектов);
	Возврат Текст;
КонецФункции

Функция ОбработатьТекстЗапросаПоВидуРеквизита(ТекстЗапроса, ВидРеквизита, ТипОбъектов = Неопределено) Экспорт
	Если ВидРеквизита = "ДС" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицы", "РегистрСведений.ДополнительныеСведения");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДопРеквизиты.Ссылка", "ДопРеквизиты.Объект");
	ИначеЕсли ВидРеквизита = "А1" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицы", "РегистрСведений.А1_Реквизиты");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДопРеквизиты.Ссылка", "ДопРеквизиты.Объект");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДопРеквизиты.Свойство.Имя", "ДопРеквизиты.Свойство");
	ИначеЕсли ВидРеквизита = "А1П" Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ТаблицаРеквизитов.Имя КАК Имя,
		|	ТаблицаРеквизитов.Ключ КАК Ключ
		|ПОМЕСТИТЬ ТаблицаРеквизитов
		|ИЗ
		|	&ТаблицаРеквизитов КАК ТаблицаРеквизитов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодическиеРеквизиты.Объект КАК Ссылка,
		|	ТаблицаРеквизитов.Имя КАК Имя,
		|	ЕСТЬNULL(ПериодическиеРеквизиты.Значение, НЕОПРЕДЕЛЕНО) КАК Значение
		|ИЗ
		|	ТаблицаРеквизитов КАК ТаблицаРеквизитов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.А1_ПериодическиеРеквизиты.СрезПоследних(&Период, ) КАК ПериодическиеРеквизиты
		|		ПО ТаблицаРеквизитов.Ключ = ПериодическиеРеквизиты.КлючРеквизита
		|			И (ПериодическиеРеквизиты.Объект В (&Ссылки))";
	ИначеЕсли ВидРеквизита = "А1Д" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицы", "РегистрСведений.А1Д_ДопПоля");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДопРеквизиты.Ссылка", "ДопРеквизиты.Объект");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДопРеквизиты.Свойство.Имя", "ДопРеквизиты.Свойство");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДопРеквизиты.Значение КАК Значение", "ДопРеквизиты.Примитив КАК ЗначениеПримитив, ДопРеквизиты.Ссылка КАК ЗначениеСсылка"); 
	Иначе
		Если ТипОбъектов = Неопределено Тогда
			А1Э_Служебный.ИсключениеНеверныйТип("ТипОбъектов", "ОбработатьТекстЗапросаПоВидуРеквизита", "Неопределено", "Тип");
		КонецЕсли;
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицы", Метаданные.НайтиПоТипу(ТипОбъектов).ПолноеИмя() + ".ДополнительныеРеквизиты"); 
	КонецЕсли;
КонецФункции

Функция ВыполнитьДействияДляПолученияПериодическихРеквизитов(Запрос, ИменаРеквизитов, Контекст)
	Запрос.УстановитьПараметр("Период", А1Э_Структуры.ЗначениеСвойства(Контекст, "Период", ТекущаяДата()));
	ТаблицаРеквизитов = Новый ТаблицаЗначений;
	А1Э_ТаблицыЗначений.ДобавитьКолонку(ТаблицаРеквизитов, "Имя", "Строка:100");
	А1Э_ТаблицыЗначений.ДобавитьКолонку(ТаблицаРеквизитов, "Ключ", "Число:10");
	
	Для Каждого Имя Из ИменаРеквизитов Цикл
		Описание = А1Э_ПериодическиеРеквизиты.ОписаниеПоИмени(Имя);
		СтрокаРеквизита = ТаблицаРеквизитов.Добавить();
	    ЗаполнитьЗначенияСвойств(СтрокаРеквизита, Описание);
	КонецЦикла;
	Запрос.УстановитьПараметр("ТаблицаРеквизитов", ТаблицаРеквизитов);
КонецФункции

#КонецОбласти 

#Область А1_ИменаДопРеквизитов

#Если Сервер Или ВнешнееСоединение Тогда
	
	Функция ДобавитьИмена(ТаблицаИмен) Экспорт
		А1Э_ДопРеквизиты.ДобавитьИмя(ТаблицаИмен, ИмяОбъекта_ИмяРеквизита());
	КонецФункции 
	
#КонецЕсли

Функция ИмяОбъекта_ИмяРеквизита() Экспорт
	Возврат "ИмяОбъекта_ИмяРеквизита";	
КонецФункции

#КонецОбласти 

Функция ИмяМодуля() Экспорт
	Возврат "А1Э_ДопРеквизиты";
КонецФункции 