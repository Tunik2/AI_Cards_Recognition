clear all;

%Wczytanie zdj�cia
karta_sciezka = imgetfile;
karta = imread(karta_sciezka);

%Wst�pna obr�bka zdj�cia
karta_gray = rgb2gray(karta);
karta_binary = im2bw(karta_gray);
karta_binary = bwareaopen(karta_binary, 35, 4);

%R�czny wyb�r znaku oraz koloru karty na zdj�ciu
figure('NumberTitle', 'off', 'Name', 'Wybierz znak karty');
imshow(karta_binary);

znak = imcrop;

close all;

figure('NumberTitle', 'off', 'Name', 'Wybierz kolor karty');
imshow(karta_binary);

kolor = imcrop;

close all;

%Filtracja wyci�tych fragment�w zdj�cia
h = ones(5,5);
znak_filter = imfilter(znak,h);
kolor_filter = imfilter(kolor,h);

%Przeskalowanie wybranych fragment�w
znak_resize = imresize(znak_filter, [20 20]);
kolor_resize = imresize(kolor_filter, [20 20]);

%Zapis wybranych fragment�w w formie wektora kolumnowego
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

%Podanie na wej�cie sieci danych wej�ciowych
ZNAK = nnet_znak(znak_wej)
KOLOR = nnet_kolor(kolor_wej)

%Sprawdzenie indeksu pod kt�rym znajduje si� warto�� maksymalna odpowiedzi
%sieci na dane wej�ciowe
[Max_znak, IND_znak] = max(ZNAK);
[Max_kolor, IND_kolor] = max(KOLOR);

%Okreslenie znaku karty na podstawie uzyskanego indeksu
switch IND_znak
    case 1
        Z = 'Dw�jka';
    case 2
        Z = 'Tr�jka';
    case 3
        Z = 'Czw�rka';
    case 4
        Z = 'Pi�tka';  
    case 5
        Z = 'Sz�stka';
    case 6
        Z = 'Si�demka';
    case 7
        Z = '�semka';
    case 8
        Z = 'Dziewi�tka';         
    case 9
        Z = 'Dziesi�tka';  
    case 10
        Z = 'Jopek';
    case 11
        Z = 'Dama';
    case 12
        Z = 'Kr�l';
    case 13
        Z = 'As';
end

%Okre�lenie koloru karty na podstawie uzyskanego indeksu
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

%Z�o�enie wyniku i wyswietlenie go w konsoli
Wynik = [Z, ' ', K];

disp(Wynik);