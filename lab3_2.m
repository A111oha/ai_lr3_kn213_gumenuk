% Створення нечіткої моделі для керування кондиціонером
fis = mamfis('Name', 'AirConditionerControl');

% Вхідна змінна "Temperature"
fis = addInput(fis, [0 40], 'Name', 'Temperature');
fis = addMF(fis, 'Temperature', 'trapmf', [0 0 10 15], 'Name', 'VeryCold');
fis = addMF(fis, 'Temperature', 'trapmf', [10 15 25 30], 'Name', 'Cold');
fis = addMF(fis, 'Temperature', 'trimf', [20 25 30], 'Name', 'Normal');
fis = addMF(fis, 'Temperature', 'trapmf', [25 30 35 40], 'Name', 'Warm');
fis = addMF(fis, 'Temperature', 'trapmf', [30 35 40 40], 'Name', 'VeryWarm');

% Вхідна змінна "TemperatureChange"
fis = addInput(fis, [-5 5], 'Name', 'TemperatureChange');
fis = addMF(fis, 'TemperatureChange', 'trapmf', [-5 -5 -2 0], 'Name', 'Negative'); % Негативна
fis = addMF(fis, 'TemperatureChange', 'trimf', [-1 0 1], 'Name', 'Zero'); % Нульова
fis = addMF(fis, 'TemperatureChange', 'trapmf', [0 2 5 5], 'Name', 'Positive'); % Позитивна

% Вихідна змінна "Control"
fis = addOutput(fis, [-30 30], 'Name', 'Control');
fis = addMF(fis, 'Control', 'trapmf', [-30 -30 -20 -10], 'Name', 'LargeLeft');
fis = addMF(fis, 'Control', 'trimf', [-20 -10 0], 'Name', 'SmallLeft');
fis = addMF(fis, 'Control', 'trimf', [-1 0 1], 'Name', 'Off');
fis = addMF(fis, 'Control', 'trimf', [0 10 20], 'Name', 'SmallRight');
fis = addMF(fis, 'Control', 'trapmf', [10 20 30 30], 'Name', 'LargeRight');

% Додавання правил
rules = [
    "Temperature==VeryWarm & TemperatureChange==Positive => Control=LargeLeft (1)"
    "Temperature==VeryWarm & TemperatureChange==Negative => Control=SmallLeft (1)"
    "Temperature==Warm & TemperatureChange==Positive => Control=LargeLeft (1)"
    "Temperature==Warm & TemperatureChange==Negative => Control=SmallLeft (1)"
    "Temperature==Cold & TemperatureChange==Positive => Control=SmallRight (1)"
    "Temperature==Cold & TemperatureChange==Negative => Control=LargeRight (1)"
    "Temperature==VeryCold & TemperatureChange==Positive => Control=SmallRight (1)"
    "Temperature==VeryCold & TemperatureChange==Negative => Control=LargeRight (1)"
    "Temperature==VeryWarm & TemperatureChange==Zero => Control=LargeLeft (1)"
    "Temperature==Warm & TemperatureChange==Zero => Control=SmallLeft (1)"
    "Temperature==Normal & TemperatureChange==Zero => Control=Off (1)"
    "Temperature==Cold & TemperatureChange==Zero => Control=SmallRight (1)"
    "Temperature==VeryCold & TemperatureChange==Zero => Control=LargeRight (1)"
    "Temperature==Normal & TemperatureChange==Positive => Control=SmallLeft (1)"
    "Temperature==Normal & TemperatureChange==Negative => Control=SmallRight (1)"
];

% Додавання правил до нечіткої системи
fis = addRule(fis, rules);

% Виведення правил у консоль
disp('Додані правила:');
ruleList = showrule(fis);
disp(ruleList);

% Візуалізація вхідних і вихідних змінних
figure;
subplot(3, 1, 1);
plotmf(fis, 'input', 1);
title('Temperature');

subplot(3, 1, 2);
plotmf(fis, 'input', 2);
title('TemperatureChange');

subplot(3, 1, 3);
plotmf(fis, 'output', 1);
title('Control');

% Перевірка поверхні правил
figure;
gensurf(fis);
title('Rule Surface');


