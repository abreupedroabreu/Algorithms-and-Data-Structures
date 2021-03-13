function stft(data, window, hopSize, nfft, fs)
    data = data(:);
    tData = length(data); % - Tamanho do Sinal - %
    tWin = length(window); % - Tamanho da Janela - %
    
    pFFT = ceil((1+nfft)/2); % - Numero de pontos unicos FFT - %
    f = 1+fix((tData-tWin)/hopSize); % - Numero de frames do sinal - %
    STFT = zeros(pFFT,f); % - Inicia-se a variavel STFT - %
    
    % - Obtemos a STFT - %
    for i = 0:f-1
        dataW = data(1+i*hopSize:tWin+i*hopSize).*window; % - Windowing - %
        
        X = fft(dataW,nfft); % - FFT - %

        STFT(:,1+i) = X(1:pFFT); % - Atualiza a matriz da STFT
    end
    
    t = (tWin/2:hopSize/2+(f-1)*hopSize)/fs; % - vetor tempo - %
    f = (0:pFFT-1)*fs/nfft; % - vetor frequecia - %
    STFT = mag2db(abs(STFT)); % - Convert amplitude spectrum to dB - %
     
    % - Representacao Grafica - %

    clims = [-100 60]; % - Set colour scale range (dB) - %
    figure()
    imagesc(t,f,STFT,clims)
    colorbar
    axis xy
    xlabel('TIME (s)')
    ylabel('FREQUENCY (Hz)')
    title('Short-time Fourier Transform');
end

% ------------------------------------- %
%               - INFO -                %
% ------------------------------------- %
% data - signal                         %
% window - window function              %
% hopSize - hop Size                    %
% nfft - numer of FFT points            %
% fs - sampling frequency [in Hz]       % 
% ------------------------------------- %
% STFT -  Short-time Fourier Transform  %
% f - frequency vector [in Hz]          %
% t - time vector [in s]                %
% ------------------------------------- %
