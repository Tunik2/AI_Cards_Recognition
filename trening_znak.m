clear all;

%Wczytanie zdj�cia i wst�pna obr�bka
znaki = imread('znaki.jpg');
znaki_gray = rgb2gray(znaki);
znaki_binary = im2bw(znaki_gray);

%Utworzenie macierzy,wektor�w i zmienych wykorzystanych w p�tli for
znak = zeros(20,20);
znak_wek = zeros(1,400);
znaki_macierz = zeros(400,520);

k=0;
wiersz = 1;
kolumna = 1;
wiersz_wsk = 1;
kolumna_wsk = 1;

%Przekszta�cenie zdj�cia do formy odpowiedniej by za jego pomoc� wytrenowa�
%sie� neuronow�
for z = 1:520
    
for i = 1:20
    for j = 1:20
        
        znak(i,j) = znaki_binary(wiersz,kolumna);
        
        if i == 20 && j == 20
            kolumna_wsk = kolumna_wsk+20;
            if kolumna_wsk == 801
                kolumna_wsk = 1;
                wiersz_wsk = wiersz_wsk + 20;
            end
        elseif j == 20
            kolumna = kolumna_wsk;
            wiersz = wiersz +1;
        end
        
        if j ~= 20
        kolumna=kolumna+1;
        end
        
    end
end

wiersz = wiersz_wsk;
kolumna = kolumna_wsk;

for i = 1:20
    for j = 1:20
        znak_wek(k+j) = znak(i,j);
        if j == 20
            k=k+20;
        end
    end
end

k=0;
znaki_macierz(:,z) = znak_wek;

end

%Wczytanie danych z Excela
znaki_wyj = xlsread('trening_wyj_znak');

%Utworzenie struktury sieci z 50 neuronami ukrytymi
net_znak = feedforwardnet(50);

%Trening sieci
nnet_znak = train(net_znak,znaki_macierz,znaki_wyj);

%Zapisanie wytrenowanej zmiennej
save ('sieci_znak.mat','nnet_znak');