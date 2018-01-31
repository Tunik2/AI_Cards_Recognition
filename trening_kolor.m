clear all;

%Wczytanie zdjêcia i wstêpna obróbka
kolory = imread('kolory.jpg');
kolory_gray = rgb2gray(kolory);
kolory_binary = im2bw(kolory_gray);

%Utworzenie macierzy,wektorów i zmienych wykorzystanych w pêtli for
kolor = zeros(20,20);
kolor_wek = zeros(1,400);
kolory_macierz = zeros(400,160);

k=0;
wiersz = 1;
kolumna = 1;
wiersz_wsk = 1;
kolumna_wsk = 1;

%Przekszta³cenie zdjêcia do formy odpowiedniej by za jego pomoc¹ wytrenowaæ
%sieæ neuronow¹
for z = 1:160
    
for i = 1:20
    for j = 1:20
  
        kolor(i,j) = kolory_binary(wiersz,kolumna);
        
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
        kolor_wek(k+j) = kolor(i,j);
        if j == 20
            k=k+20;
        end
    end
end

k=0;
kolory_macierz(:,z) = kolor_wek;

end

%Wczytanie danych z Excela
kolory_wyj = xlsread('trening_wyj_kolor');

%Utworzenie struktury sieci z 50 neuronami ukrytymi
net_kolor = feedforwardnet(50);

%Trening sieci
nnet_kolor = train(net_kolor,kolory_macierz,kolory_wyj);

%Zapisanie wytrenowanej zmiennej
save ('sieci_kolor.mat', 'nnet_kolor');