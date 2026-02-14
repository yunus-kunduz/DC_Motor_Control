%% DC Motor Speed Control Project
clear all; close all; clc;

% 1. Motor Parametreleri
R = 1.0;      % Direnç (Ohm)
L = 0.5;      % Endüktans (Henry)
K = 0.01;     % Motor tork ve back-EMF sabiti
J = 0.01;     % Rotor eylemsizlik momenti (kg.m^2)
b = 0.1;      % Sürtünme katsayısı (N.m.s)

% 2. Transfer Fonksiyonu Oluşturma
% G(s) = Omega(s) / V(s)
s = tf('s');
P_motor = K / ((J*s+b)*(L*s+R) + K^2);

% 3. Sonuçları Command Window'da Göster
fprintf('Motor Transfer Fonksiyonu:\n');
display(P_motor);

% 4. Açık Döngü (Kontrolsüz) Yanıtı Çizdir
figure('Name', 'DC Motor Analysis');
step(P_motor);
title('DC Motor Open-Loop Step Response (Uncontrolled)');
grid on;

% 5. PID Kontrolcü Tasarımı
Kp = 100;
Ki = 200;
Kd = 10;

C = pid(Kp, Ki, Kd);

% 6. Kapalı Döngü Sistemi Oluşturma (Feedback)
T = feedback(C*P_motor, 1);

% 7. Kontrolsüz vs Kontrollü Karşılaştırması
figure('Name', 'PID Control Comparison');
step(P_motor, 'r', T, 'b');
title('DC Motor: Uncontrolled (Red) vs PID Controlled (Blue)');
legend('Uncontrolled', 'PID Controlled');
grid on;

% 8. Otomatik Tuning
[C_tuned, info] = pidtune(P_motor, 'PID');
T_tuned = feedback(C_tuned*P_motor, 1);

figure('Name', 'Optimized PID Control');
step(T, 'b', T_tuned, 'g');
legend('Manuel PID', 'MATLAB Optimized PID');
title('Manuel vs Otomatik Tune Karşılaştırması');
grid on;

fprintf('MATLAB tarafından önerilen katsayılar:\n');
C_tuned;