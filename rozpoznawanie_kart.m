clear all;

%Wczytanie zdjêcia
karta_sciezka = imgetfile;
karta = imread(karta_sciezka);

%Wstêpna obróbka zdjêcia
karta_gray = rgb2gray(karta);
karta_binary = im2bw(karta_gray);
karta_binary = bwareaopen(karta_binary, 35, 4);

%Rêczny wybór znaku oraz koloru karty na zdjêciu
figure('NumberTitle', 'off', 'Name', 'Wybierz znak karty');
imshow(karta_binary);

znak = imcrop;

close all;

figure('NumberTitle', 'off', 'Name', 'Wybierz kolor karty');
imshow(karta_binary);

kolor = imcrop;

close all;

%Filtracja wyciêtych fragmentów zdjêcia
h = ones(5,5);
znak_filter = imfilter(znak,h);
kolor_filter = imfilter(kolor,h);

%Przeskalowanie wybranych fragmentów
znak_resize = imresize(znak_filter, [20 20]);
kolor_resize = imresize(kolor_filter, [20 20]);

%Zapis wybranych fragmentów w formie wektora kolumnowego
znak_wej = zeros(1,400);
kolor_wej = zeros(1,400);
k=0;

for i = 1:20
    for j = 1:20
        znak_wej(k+j) = znak_resize(i,j);
        kolor_wej(k+j) = kolor_resize(i,j);
        if j == 20
            k=k+20;
        end
    end
end

znak_wej = znak_wej';
kolor_wej = kolor_wej';

%Wczytanie wyuczonych sieci neuronowych
load sieci_znak.mat
load sieci_kolor.mat

%Podanie na wejœcie sieci danych wejœciowych
ZNAK = nnet_znak(znak_wej)
KOLOR = nnet_kolor(kolor_wej)

%Sprawdzenie indeksu pod którym znajduje siê wartoœæ maksymalna odpowiedzi
%sieci na dane wejœciowe
[Max_znak, IND_znak] = max(ZNAK);
[Max_kolor, IND_kolor] = max(KOLOR);

%Okreslenie znaku karty na podstawie uzyskanego indeksu
switch IND_znak
    case 1
        Z = 'Dwójka';
    case 2
        Z = 'Trójka';
    case 3
        Z = 'Czwórka';
    case 4
        Z = 'Pi¹tka';  
    case 5
        Z = 'Szóstka';
    case 6
        Z = 'Siódemka';
    case 7
        Z = 'Ósemka';
    case 8
        Z = 'Dziewi¹tka';         
    case 9
        Z = 'Dziesi¹tka';  
    case 10
        Z = 'Jopek';
    case 11
        Z = 'Dama';
    case 12
        Z = 'Król';
    case 13
        Z = 'As';
end

%Okreœlenie koloru karty na podstawie uzyskanego indeksu
switch IND_kolor
    case 1
        K = 'Kier';
    case 2
        K = 'Karo';
    case 3
        K = 'Pik';
    case 4
        K = 'Trefl';  
end

%Z³o¿enie wyniku i wyswietlenie go w konsoli
Wynik = [Z, ' ', K];

disp(Wynik);