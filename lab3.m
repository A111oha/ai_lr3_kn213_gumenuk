% Створення нечіткої моделі
fis = mamfis('Name', 'MixerControlSystem');

% Додавання вхідних змінних
fis = addInput(fis, [0 100], 'Name', 'Temperature'); % Температура
fis = addInput(fis, [0 10], 'Name', 'FlowRate');    % Напір

% Додавання вихідних змінних
fis = addOutput(fis, [-90 90], 'Name', 'HotWaterAngle');  % Кут для гарячої води
fis = addOutput(fis, [-90 90], 'Name', 'ColdWaterAngle'); % Кут для холодної води

% Додавання функцій належності до входів
% Температура
fis = addMF(fis, 'Temperature', 'trapmf', [0 0 15 30], 'Name', 'Cold');
fis = addMF(fis, 'Temperature', 'trimf', [25 40 55], 'Name', 'Cool');
fis = addMF(fis, 'Temperature', 'trimf', [50 65 80], 'Name', 'Warm');
fis = addMF(fis, 'Temperature', 'trimf', [75 90 100], 'Name', 'NotVeryHot');
fis = addMF(fis, 'Temperature', 'trapmf', [90 100 100 100], 'Name', 'Hot');

% Напір
fis = addMF(fis, 'FlowRate', 'trapmf', [0 0 2 4], 'Name', 'Weak');
fis = addMF(fis, 'FlowRate', 'trimf', [3 5 7], 'Name', 'NotStrong');
fis = addMF(fis, 'FlowRate', 'trapmf', [6 8 10 10], 'Name', 'Strong');

% Додавання функцій належності до виходів
% Кут для гарячої води
fis = addMF(fis, 'HotWaterAngle', 'trimf', [-90 -60 -30], 'Name', 'BigLeft');
fis = addMF(fis, 'HotWaterAngle', 'trimf', [-40 -20 0], 'Name', 'MediumLeft');
fis = addMF(fis, 'HotWaterAngle', 'trimf', [0 20 40], 'Name', 'MediumRight');
fis = addMF(fis, 'HotWaterAngle', 'trimf', [30 60 90], 'Name', 'SmallRight');

% Кут для холодної води
fis = addMF(fis, 'ColdWaterAngle', 'trimf', [-90 -60 -30], 'Name', 'BigLeft');
fis = addMF(fis, 'ColdWaterAngle', 'trimf', [-40 -20 0], 'Name', 'MediumLeft');
fis = addMF(fis, 'ColdWaterAngle', 'trimf', [0 20 40], 'Name', 'MediumRight');
fis = addMF(fis, 'ColdWaterAngle', 'trimf', [30 60 90], 'Name', 'SmallRight');

% Додавання правил
ruleList = [
    5 3 2 3 1 1; % Hot & Strong => MediumLeft, MediumRight
    5 2 2 3 1 1; % Hot & NotStrong => MediumLeft, MediumRight
    4 3 3 0 1 1; % NotVeryHot & Strong => SmallLeft, NoChange
    4 1 4 4 1 1; % NotVeryHot & Weak => SmallRight, SmallRight
    3 2 0 3 1 1; % Warm & NotStrong => NoChange, MediumRight
    2 3 3 2 1 1; % Cool & Strong => MediumRight, MediumLeft
    2 2 3 4 1 1; % Cool & NotStrong => MediumRight, SmallLeft
    1 1 4 0 1 1; % Cold & Weak => BigRight, NoChange
    1 3 2 3 1 1; % Cold & Strong => MediumLeft, MediumRight
    3 3 4 4 1 1; % Warm & Strong => SmallLeft, SmallLeft
    3 1 4 4 1 1; % Warm & Weak => SmallRight, SmallRight
];

% Додавання правил до системи
fis = addRule(fis, ruleList);

% Відображення правил
disp('Додані правила:');
for i = 1:numel(fis.Rules)
    fprintf('Правило %d: %s\n', i, fis.Rules(i).Description);
end

% Збереження FIS-моделі
writeFIS(fis, 'MixerControlSystem');

% Перевірка моделі
figure;
plotfis(fis);

% Візуалізація поверхонь
figure;
gensurf(fis);


