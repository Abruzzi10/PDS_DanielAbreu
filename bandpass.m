function yb = bandpass(x, fs, damp, minf, maxf, Fw)
    % Mudan�a da frequ�ncia central do filtro nas amostras(Hz)
    delta = Fw/fs;
    % Cria��o de uma onda triangular com os valores centrais de frequencia
    Fc=minf:delta:maxf;
    while(length(Fc) < length(x) )
        Fc= [ Fc (maxf:-delta:minf) ];
        Fc= [ Fc (minf:delta:maxf) ];
    end

    Fc = Fc(1:length(x));
    F1 = 2*sin((pi*Fc(1))/fs);
    % tamanho do passa banda � 2 vezes o valor inserido no codigo inicial
    Q1 = 2*damp;

    % cria��o de vetores vazios de sa�da
    yh=zeros(size(x));          %filtro passa alta
    yb=zeros(size(x));          %filtro passa banda
    yl=zeros(size(x));          %filtro passa baixa
    yh(1) = x(1);
    yb(1) = F1*yh(1);
    yl(1) = F1*yb(1);

    for n=2:length(x)
        yh(n) = x(n) - yl(n-1) - Q1*yb(n-1);
        yb(n) = F1*yh(n) + yb(n-1);
        yl(n) = F1*yb(n) + yl(n-1);
        F1 = 2*sin((pi*Fc(n))/fs); 
    end

    %normalizar
    maxyb = max(abs(yb));
    yb = yb./maxyb;
end