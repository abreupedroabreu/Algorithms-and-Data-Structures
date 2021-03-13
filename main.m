    
   
    clc
    clear
   
    % - Inicialização de Variáveis
    pi = 3.14;
    Fs = 50; % - Frequência de amostragem dada - %
    Atividades = ["W","W_U","W_D","SIT","STAND","LAY","STAND_SIT","SIT_STAND","SIT_LIE","LIE_SIT","STAND_LIE","LIE_STAND"];
    Experiencias =["01","02","03","04","05","06","07","08","09","10"]; % - Vetor de experiencias - %
    utilizadores = ["01","02","03","04","05"]; % - Vetor com os utilizadores - %
    eixos = ["ACC_X","ACC_Y","ACC_Z"]; % - Labels dos graficos - %
    
    todas_labels = importdata("Data\labels.txt"); % - Importa a data do ficheiro das labels - %
   
    % - Variaveil auxiliar para permitir desenhar as figuras em simultaneo - %
    utilizador_aux = 0;
    user = 1;
    
    pkWTOTAL = [];
    pkWDTOTAL = [];
    pkWUTOTAL = [];
    
    for i=1:length(Experiencias)
        if (i ~=1 && i ~= length(Experiencias)) % - Se nao tiver nem no ultimo nem no primeiro - %
            % - 1 user = 2 experiencias - %
            if (utilizador_aux == 1) % - segunda exp - %
                utilizador_aux = 0;
                user = user + 1; % - Passa para um novo utilizador pois ja contou com os dois exp do usuario anterior - %
            else % - Esta no primeiro exp - %
                utilizador_aux = utilizador_aux + 1; % - Incrementa a variavel auxiliar - %

            end
        else % - Pimeiro / Ultimo elemento do array dos exp - %
            user = i; % O valor e sempre igual a i - %
            if i == length(Experiencias) % - Ultimo elemento do array - %
                user = 5; % - Damos-lhe o ultimo elemento do array dos utilizadores - %
            end
        end
        
        % -----------EXERCICIO 2 -- Import dos sinais ---------
        
        fprintf("i = %d user = %d Experiencias{i} = %s utilizadores{user} = %s\n",i,user,Experiencias{i},utilizadores{user});
        ficheiro = sprintf("Data/acc_exp%s_user%s.txt",Experiencias(i),utilizadores(user));
      
        data = importdata(ficheiro);
        
        %- Vai ir buscar a 1a coluna do label.txt(corresponde) ao ID
        %actividade e em seguida vai comparar com a 2a coluna(id do user)
        % vai retornar um vetor com as intersecoes entre os 2(OS INDICES DO LABEL.TXT)
        
        x_labels = intersect(find(todas_labels(:,1)==str2double(Experiencias{i})),find(todas_labels(:,2)==str2double(utilizadores{user}))); % - Labels para o ficheiro correspondente - %

        t=[0:size(data,1)-1]./Fs; % indice da coluna do ficheiro experiencia / 50 que é a frequencia da amostra
        Ts = 1/Fs;  %periodo de amostragem
        
        tam = size(data);
        n_pontos =  tam(1); %n de pontos existentes, tanto para x, como y e z
        n_col = tam(2);  %colunas x,y,z
        
        
       
        %- vamos percorrer as colunas do ficheiro de experiencias
        
        % ------------- EXERCICIO 3-------------------------------
        for k=1:n_col
            
            if(i == 1)
                figure(i)
            else
               figure(i+2)
            end
                
            subplot(n_col,1,k);
            plot(t./60,data(:,k),"k--")
            axis([0 t(end)./60 min(data(:,k)) max(data(:,k))])
            xlabel("Time(min)","fontsize",16,"fontweight","bold")
            ylabel(eixos{k},"fontsize",16,"fontweight","bold")
            
            hold on 
       
            % - array onde vamos armazenar os dados de cada estado - %
            laying = [];
            lieToSit = [];
            StandToLie = [];
            LieToStand = [];
            walking = [];
            walkingUpstairs = [];
            walkingDownstairs = [];
            sitToLie = [];
            standing = [];
            sitting = [];
            standToSit = [];
            sitToStand = [];
            
            
            for j=1:length(x_labels) % - Da as labels ao grafico e tambem armazena os dados de cada estado - %
                        
                        %x:labelStartPoint--labelEndPoint y: 
                        
                plot(t(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5))./60,data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k))
                
                if (mod(j,2)) == 1 % - Verifica se deve ser em cima ou em baixo - %
                    ypos = min(data(:,k))-(0.2*min(data(:,k)));
                else
                    ypos = max(data(:,k))-(0.2*max(data(:,k)));
                end
                % - Escreve as labels - %
                text(t(todas_labels(x_labels(j),4))/60,ypos,Atividades{todas_labels(x_labels(j),3)},"VerticalAlignment","top","HorizontalAlignment","left");       
                
                % - Verifica o estado do label atual e armazena nas
                % variaveis - %
                if(Atividades{todas_labels(x_labels(j),3)} == "W")
                    walking = [walking; data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k)];
                end
                 if(Atividades{todas_labels(x_labels(j),3)} == "SIT_STAND")
                    sitToStand = [sitToStand; data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k)];
                end
                if(Atividades{todas_labels(x_labels(j),3)} == "W_U")
                    walkingUpstairs = [walkingUpstairs; data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k)];
                end
                if(Atividades{todas_labels(x_labels(j),3)} == "W_D")
                    walkingDownstairs = [walkingDownstairs; data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k)];
                end
                if(Atividades{todas_labels(x_labels(j),3)} == "STAND_SIT")
                    standToSit = [standToSit; data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k)];
                end
                if(Atividades{todas_labels(x_labels(j),3)} == "LIE_SIT")
                    lieToSit = [lieToSit; data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k)];
                end
                if(Atividades{todas_labels(x_labels(j),3)} == "SIT")
                    sitting = [sitting; data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k)];
                end
                if(Atividades{todas_labels(x_labels(j),3)} == "STAND_LIE")
                    StandToLie = [StandToLie; data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k)];
                end
                if(Atividades{todas_labels(x_labels(j),3)} == "LIE_STAND")
                    LieToStand = [LieToStand; data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k)];
                end
                if(Atividades{todas_labels(x_labels(j),3)} == "SIT_LIE")
                    sitToLie = [sitToLie; data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k)];
                end
                if(Atividades{todas_labels(x_labels(j),3)} == "STAND")
                    standing = [standing; data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k)];
                end
               
                if(Atividades{todas_labels(x_labels(j),3)} == "LAY")
                    laying = [laying; data(todas_labels(x_labels(j),4):todas_labels(x_labels(j),5),k)];
                end
            end
            
            % - 4  Calculo da DFT
            
                % --------EXERCICIO 4.1 ------------------ %
                
                % - WALKING UPSTAIRS - %
                WalkingUpstairs_X = abs(walkingUpstairs); % - Magnitude do Sinal - %

                % - Janela de Hamming - %
                h = hamming(length(WalkingUpstairs_X));  
                WUHamming_X = abs(fftshift(fft(WalkingUpstairs_X.*h)));    % - Obtemos a DFT da magnitude vezes a janela - %

                WalkingUpstairsH_N = numel(WUHamming_X); % - Periodo Fundamental - % 
                tt_WalkingUpstairsH = linspace(0,(WalkingUpstairsH_N-1)/Fs,WalkingUpstairsH_N);

                % - Janela de Backman  - %
                b = blackman(length(WalkingUpstairs_X));
                WUBackman_X = abs(fftshift(fft(WalkingUpstairs_X.*b)));

                N_WalkingUpstairsB = numel(WUBackman_X); % - Periodo Fundamental - % 
                tt_WalkingUpstairsB = linspace(0,(N_WalkingUpstairsB-1)/Fs,N_WalkingUpstairsB);

                % - Janela Flat Top - %
                f = flattopwin(length(WalkingUpstairs_X));
                X_WUFlatTop = abs(fftshift(fft(WalkingUpstairs_X.*f)));

                N_WalkingUpstairsF = numel(X_WUFlatTop); % - Periodo Fundamental - % 
                tt_WalkingUpstairsF = linspace(0,(N_WalkingUpstairsF-1)/Fs,N_WalkingUpstairsF);
                
                %-----------------------------------------------------------------------------------
     
                % - WALKING - %

                Walking_X = abs(walking); % - Magnitude do Sinal - %

                % - Janela de Hamming - %
                h = hamming(length(Walking_X));  
                WHamming_X = abs(fftshift(fft(Walking_X.*h)));    % - Obtemos a DFT da magnitude vezes a janela - %

                N_WalkingH = numel(WHamming_X); % - Periodo Fundamental - % 
                tt_WalkingH = linspace(0,(N_WalkingH-1)/Fs,N_WalkingH);

                % - Janela de Backman  - %
                b = blackman(length(Walking_X));
                X_WBackman = abs(fftshift(fft(Walking_X.*b)));

                N_WalkingB = numel(X_WBackman); % - Periodo Fundamental - % 
                tt_WalkingB = linspace(0,(N_WalkingB-1)/Fs,N_WalkingB);

                % - Janela Flat Top - %
                f = flattopwin(length(Walking_X));
                X_WFlatTop = abs(fftshift(fft(Walking_X.*f)));

                N_WalkingF = numel(X_WFlatTop); % - Periodo Fundamental - % 
                tt_WalkingF = linspace(0,(N_WalkingF-1)/Fs,N_WalkingF);
                
                %- --------------------------------------------------------
                
                % - WALKING DOWNSTAIRS - %
                Walking_XDownstairs = abs(walkingDownstairs); % - Magnitude do Sinal - %

                % - Janela de Hamming - %
                h = hamming(length(Walking_XDownstairs));  
                WDHamming_X = abs(fftshift(fft(Walking_XDownstairs.*h)));    % - Obtemos a DFT da magnitude vezes a janela - %

                N_WalkingDownstairsH = numel(WDHamming_X); % - Periodo Fundamental - % 
                tt_WalkingDownstairsH = linspace(0,(N_WalkingDownstairsH-1)/Fs,N_WalkingDownstairsH);

                % - Janela de Backman  - %
                b = blackman(length(Walking_XDownstairs));
                X_WDBackman = abs(fftshift(fft(Walking_XDownstairs.*b)));

                N_WalkingDownstairsB = numel(X_WDBackman); % - Periodo Fundamental - % 
                tt_WalkingDownstairsB = linspace(0,(N_WalkingDownstairsB-1)/Fs,N_WalkingDownstairsB);

                % - Janela Flat Top - %
                f = flattopwin(length(Walking_XDownstairs));
                X_WDFlatTop = abs(fftshift(fft(Walking_XDownstairs.*f)));

                N_WalkingDownstairsF = numel(X_WDFlatTop); % - Periodo Fundamental - % 
                tt_WalkingDownstairsF = linspace(0,(N_WalkingDownstairsF-1)/Fs,N_WalkingDownstairsF);

                %---------------------------------------------------------------
               
                % - SIT TO STAND - %
                sitToStand_X = abs(sitToStand); % - Magnitude do Sinal - %

                % - Janela de Hamming - %
                h = hamming(length(sitToStand_X));  
                SitTSHamming_X = abs(fftshift(fft(sitToStand_X.*h)));    % - Obtemos a DFT da magnitude vezes a janela - %

                N_sitToStandH = numel(SitTSHamming_X); % - Periodo Fundamental - % 
                tt_sitToStandH = linspace(0,(N_sitToStandH-1)/Fs,N_sitToStandH);

                % - Janela de Backman  - %
                b = blackman(length(sitToStand_X));
                X_SitTSBackman = abs(fftshift(fft(sitToStand_X.*b)));

                N_sitToStandB = numel(X_SitTSBackman); % - Periodo Fundamental - % 
                tt_sitToStandB = linspace(0,(N_sitToStandB-1)/Fs,N_sitToStandB);

                % - Janela Flat Top - %
                f = flattopwin(length(sitToStand_X));
                X_SitTSFlatTop = abs(fftshift(fft(sitToStand_X.*f)));

                N_sitToStandF = numel(X_SitTSFlatTop); % - Periodo Fundamental - % 
                tt_sitToStandF = linspace(0,(N_sitToStandF-1)/Fs,N_sitToStandF);
                
                %-------------------------------------------------------------------------
                
                % - SIT TO LIE - %
                sitToLie_X = abs(sitToLie); % - Magnitude do Sinal - %

                % - Janela de Hamming - %
                h = hamming(length(sitToLie_X));  
                SitTLHamming_X = abs(fftshift(fft(sitToLie_X.*h)));    % - Obtemos a DFT da magnitude vezes a janela - %

                N_sitToLieH = numel(SitTLHamming_X); % - Periodo Fundamental - % 
                tt_sitToLieH = linspace(0,(N_sitToLieH-1)/Fs,N_sitToLieH);

                % - Janela de Backman  - %
                b = blackman(length(sitToLie_X));
                X_SitTLBackman = abs(fftshift(fft(sitToLie_X.*b)));

                N_sitToLieB = numel(X_SitTLBackman); % - Periodo Fundamental - % 
                tt_sitToLieB = linspace(0,(N_sitToLieB-1)/Fs,N_sitToLieB);

                % - Janela Flat Top - %
                f = flattopwin(length(sitToLie_X));
                X_SitTLFlatTop = abs(fftshift(fft(sitToLie_X.*f)));

                N_sitToLieF = numel(X_SitTLFlatTop); % - Periodo Fundamental - % 
                tt_sitToLieF = linspace(0,(N_sitToLieF-1)/Fs,N_sitToLieF);
                
                %------------------------------------------------------------------
                % - STAND TO SIT - %
                
                standToSit_X = abs(standToSit); % - Magnitude do Sinal - %

                % - Janela de Hamming - %
                h = hamming(length(standToSit_X));  
                STSHamming_X = abs(fftshift(fft(standToSit_X.*h)));    % - Obtemos a DFT da magnitude vezes a janela - %

                N_standToSitH = numel(STSHamming_X); % - Periodo Fundamental - % 
                tt_standToSitH = linspace(0,(N_standToSitH-1)/Fs,N_standToSitH);

                % - Janela de Backman  - %
                b = blackman(length(standToSit_X));
                X_STSBackman = abs(fftshift(fft(standToSit_X.*b)));

                N_standToSitB = numel(X_STSBackman); % - Periodo Fundamental - % 
                tt_standToSitB = linspace(0,(N_standToSitB-1)/Fs,N_standToSitB);

                % - Janela Flat Top - %
                f = flattopwin(length(standToSit_X));
                X_STSFlatTop = abs(fftshift(fft(standToSit_X.*f)));

                N_standToSitF = numel(X_STSFlatTop); % - Periodo Fundamental - % 
                tt_standToSitF = linspace(0,(N_standToSitF-1)/Fs,N_standToSitF);
                
                %--------------------------------------------------------

                % - STAND TO LIE - %
                StandToLie_X = abs(StandToLie); % - Magnitude do Sinal - %

                % - Janela de Hamming - %
                h = hamming(length(StandToLie_X));  
                STLHamming_X = abs(fftshift(fft(StandToLie_X.*h)));    % - Obtemos a DFT da magnitude vezes a janela - %

                N_StandToLieH = numel(STLHamming_X); % - Periodo Fundamental - % 
                tt_StandToLieH = linspace(0,(N_StandToLieH-1)/Fs,N_StandToLieH);

                % - Janela de Backman  - %
                b = blackman(length(StandToLie_X));
                X_STLBackman = abs(fftshift(fft(StandToLie_X.*b)));

                N_StandToLieB = numel(X_STLBackman); % - Periodo Fundamental - % 
                tt_StandToLieB = linspace(0,(N_StandToLieB-1)/Fs,N_StandToLieB);

                % - Janela Flat Top - %
                f = flattopwin(length(StandToLie_X));
                X_STLFlatTop = abs(fftshift(fft(StandToLie_X.*f)));

                N_StandToLieF = numel(X_STLFlatTop); % - Periodo Fundamental - % 
                tt_StandToLieF = linspace(0,(N_StandToLieF-1)/Fs,N_StandToLieF);
                %----------------------------------------------------------------
                
                % - LIE TO SIT - %
                LieToSit_X = abs(lieToSit); % - Magnitude do Sinal - %

                % - Janela de Hamming - %
                h = hamming(length(LieToSit_X));  
                LTSIHamming_X = abs(fftshift(fft(LieToSit_X.*h)));    % - Obtemos a DFT da magnitude vezes a janela - %

                N_LieToSitH = numel(LTSIHamming_X); % - Periodo Fundamental - % 
                tt_LieToSitH = linspace(0,(N_LieToSitH-1)/Fs,N_LieToSitH);

                % - Janela de Backman  - %
                b = blackman(length(LieToSit_X));
                X_LTSIBackman = abs(fftshift(fft(LieToSit_X.*b)));

                N_LieToSitB = numel(X_LTSIBackman); % - Periodo Fundamental - % 
                tt_LieToSitB = linspace(0,(N_LieToSitB-1)/Fs,N_LieToSitB);

                % - Janela Flat Top - %
                f = flattopwin(length(LieToSit_X));
                X_LTSIFlatTop = abs(fftshift(fft(LieToSit_X.*f)));

                N_LieToSitF = numel(X_LTSIFlatTop); % - Periodo Fundamental - % 
                tt_LieToSitF = linspace(0,(N_LieToSitF-1)/Fs,N_LieToSitF);
                
                %-----------------------------------------------------------
                % - LIE TO STAND - %
                LieToStand_X = abs(LieToStand); % - Magnitude do Sinal - %

                % - Janela de Hamming - %
                h = hamming(length(LieToStand_X));  
                LTSHamming_X = abs(fftshift(fft(LieToStand_X.*h)));    % - Obtemos a DFT da magnitude vezes a janela - %

                N_LieToStandH = numel(LTSHamming_X); % - Periodo Fundamental - % 
                tt_LieToStandH = linspace(0,(N_LieToStandH-1)/Fs,N_LieToStandH);

                % - Janela de Backman  - %
                b = blackman(length(LieToStand_X));
                X_LTSBackman = abs(fftshift(fft(LieToStand_X.*b)));

                N_LieToStandB = numel(X_LTSBackman); % - Periodo Fundamental - % 
                tt_LieToStandB = linspace(0,(N_LieToStandB-1)/Fs,N_LieToStandB);

                % - Janela Flat Top - %
                f = flattopwin(length(LieToStand_X));
                X_LTSFlatTop = abs(fftshift(fft(LieToStand_X.*f)));

                N_LieToStandF = numel(X_LTSFlatTop); % - Periodo Fundamental - % 
                tt_LieToStandF = linspace(0,(N_LieToStandF-1)/Fs,N_LieToStandF);
                
                
                %-------------------------------------------------------------

                % - STANDING - %
                standing_X = abs(standing); % - Magnitude do Sinal - %

                % - Janela de Hamming - %
                h = hamming(length(standing_X));  
                SHamming_X = abs(fftshift(fft(standing_X.*h)));    % - Obtemos a DFT da magnitude vezes a janela - %

                N_standingH = numel(SHamming_X); % - Periodo Fundamental - % 
                tt_standingH = linspace(0,(N_standingH-1)/Fs,N_standingH);

                % - Janela de Backman  - %
                b = blackman(length(standing_X));
                X_SBackman = abs(fftshift(fft(standing_X.*b)));

                N_standingB = numel(X_SBackman); % - Periodo Fundamental - % 
                tt_standingB = linspace(0,(N_standingB-1)/Fs,N_standingB);

                % - Janela Flat Top - %
                f = flattopwin(length(standing_X));
                X_SFlatTop = abs(fftshift(fft(standing_X.*f)));

                N_standingF = numel(X_SFlatTop); % - Periodo Fundamental - % 
                tt_standingF = linspace(0,(N_standingF-1)/Fs,N_standingF);
                
                %--------------------------------------------------------------

                % - SITTING - %
                sitting_X = abs(sitting); % - Magnitude do Sinal - %

                % - Janela de Hamming - %
                h = hamming(length(sitting_X));  
                STHamming_X = abs(fftshift(fft(sitting_X.*h)));    % - Obtemos a DFT da magnitude vezes a janela - %

                N_sittingH = numel(STHamming_X); % - Periodo Fundamental - % 
                tt_sittingH = linspace(0,(N_sittingH-1)/Fs,N_sittingH);

                % - Janela de Backman  - %
                b = blackman(length(sitting_X));
                X_SBackman = abs(fftshift(fft(sitting_X.*b)));

                N_sittingB = numel(X_SBackman); % - Periodo Fundamental - % 
                tt_sittingB = linspace(0,(N_sittingB-1)/Fs,N_sittingB);

                % - Janela Flat Top - %
                f = flattopwin(length(sitting_X));
                X_SFlatTop = abs(fftshift(fft(sitting_X.*f)));

                N_sittingF = numel(X_SFlatTop); % - Periodo Fundamental - % 
                tt_sittingF = linspace(0,(N_sittingF-1)/Fs,N_sittingF);
                
                %-------------------------------------------------------------------------------
                % - LAYING - %
                laying_X = abs(laying); % - Magnitude do Sinal - %

                % - Janela de Hamming - %
                h = hamming(length(laying_X));  
                LHamming_X = abs(fftshift(fft(laying_X.*h)));    % - Obtemos a DFT da magnitude vezes a janela - %

                N_layingH = numel(LHamming_X); % - Periodo Fundamental - % 
                tt_layingH = linspace(0,(N_layingH-1)/Fs,N_layingH);

                % - Janela de Backman  - %
                b = blackman(length(laying_X));
                X_LBackman = abs(fftshift(fft(laying_X.*b)));

                N_layingB = numel(X_LBackman); % - Periodo Fundamental - % 
                tt_layingB = linspace(0,(N_layingB-1)/Fs,N_layingB);

                % - Janela Flat Top - %
                f = flattopwin(length(laying_X));
                X_LFlatTop = abs(fftshift(fft(laying_X.*f)));

                N_layingF = numel(X_LFlatTop); % - Periodo Fundamental - % 
                tt_layingF = linspace(0,(N_layingF-1)/Fs,N_layingF);
                
                %------------------------------------------------------------------------------
                
                

                % ----------EXERCICIO 4.2 --------------- %
                
                % - WALKING - %
                X_W = detrend(WHamming_X);
                [pksW,locsW] = findpeaks(X_W); % - Obtemos o valor do pico utilizando a funcao findpeaks - %

                pkWTOTAL = [pkWTOTAL; pksW];

                % - WALKING UPSTAIRS - %
                X_WU = detrend(WUHamming_X);
                [pksWU,locsWU] = findpeaks(X_WU);

                pkWUTOTAL = [pkWUTOTAL; pksWU];
                
                % - WALKING DOWNSTAIRS - %
                X_WD = detrend(WDHamming_X);
                [pksWD,locsWD] = findpeaks(X_WD);

                pkWDTOTAL = [pkWDTOTAL; pksWD];
                
                if(i==1)
                    
                    %- JANELAS DESLIZANTES WALKING ( dinamica )
                    
                    
                    janelasDeslizantes(30,tt_WalkingH, WHamming_X, tt_WalkingB, X_WBackman,tt_WalkingF,X_WFlatTop)
                    
                    %- JANELAS DESLIZANTES STAND TO SIT ( transicao )
                    
                    janelasDeslizantes(31,tt_standToSitH, STSHamming_X, tt_standToSitB, X_STSBackman,tt_standToSitF,X_STSFlatTop)
                    
                    %- JANELAS DESLIZANTES LAYING ( estatica )
                    
                    janelasDeslizantes(32,tt_layingH, LHamming_X, tt_layingB, X_LBackman,tt_layingF,X_LFlatTop)
                end
               
             %-------------------------------------------------------------------------
               
                % ------------EXERCICIO 4.3 -------------------- %
                

             %---------------------------------------------------------------------
                
                % - STANDING - %
                % calculo do vetor da frequencia %
                if(mode(N_standingH,2)==0) % - Numero de pontos PAR - %
                    f_standing = -Fs/2:Fs/N_standingH:Fs/2-Fs/N_standingH;
                else % - Numero de pontos IMPAR - %
                    f_standing = -Fs/2+Fs/(2*N_standingH):Fs/N_standingH:Fs/2-Fs/(2*N_standingH);
                end

                y = fftshift(fft(standing)); 
                m = abs(y);
                y(m<1e-6) = 0;
                pS = unwrap(angle(y)); % Calculo da Phase 

                
                %---------------------------------------------------------------------
                
                % - SITTING - %
                % calculo do vetor da frequencia %
                if(mode(N_sittingH,2)==0) % - Numero de pontos PAR - %
                    f_sitting = -Fs/2:Fs/N_sittingH:Fs/2-Fs/N_sittingH;
                else % - Numero de pontos IMPAR - %
                    f_sitting = -Fs/2+Fs/(2*N_sittingH):Fs/N_sittingH:Fs/2-Fs/(2*N_sittingH);
                end

                y = fftshift(fft(sitting)); 
                m = abs(y);
                y(m<1e-6) = 0;
                pSit = unwrap(angle(y)); % Calculo da Phase
                
                % o m vai ser o vetor final da frequencia
                % a magnitude já a calculamos em cima, basta ir buscar os
                % valores. A phase calculamos aqui. Vamos entao, construir
                % os gráficos pedidos :)
                

                
                %-----------------------------------------------------------------
                
                % - LAYING - %
                % calculo do vetor da frequencia %
                if(mode(N_layingH,2)==0) % - Numero de pontos PAR - %
                    f_laying = -Fs/2:Fs/N_layingH:Fs/2-Fs/N_layingH;
                else % - Numero de pontos IMPAR - %
                    f_laying = -Fs/2+Fs/(2*N_layingH):Fs/N_layingH:Fs/2-Fs/(2*N_layingH);
                end

                y = fftshift(fft(laying)); 
                m = abs(y);
                y(m<1e-6) = 0;
                pL = unwrap(angle(y)); % Calculo da Phase 

                

                %-------------------------------------------------------------------
                
                % - SIT TO STAND - %
                % calculo do vetor da frequencia %
                if(mode(N_sitToStandH,2)==0) % - Numero de pontos PAR - %
                    f_sitToStand = -Fs/2:Fs/N_sitToStandH:Fs/2-Fs/N_sitToStandH;
                else % - IMPAR - %
                    f_sitToStand = -Fs/2+Fs/(2*N_sitToStandH):Fs/N_sitToStandH:Fs/2-Fs/(2*N_sitToStandH);
                end

                y = fftshift(fft(sitToStand)); 
                m = abs(y);
                y(m<1e-6) = 0;
                pSTS = unwrap(angle(y)); % Phase 
                

                %-------------------------------------------------------------------
                
                      % - STAND TO SIT - %
                % calculo do vetor da frequencia %
                if(mode(N_standToSitH,2)==0) % - Numero de pontos PAR - %
                    f_standToSit = -Fs/2:Fs/N_standToSitH:Fs/2-Fs/N_standToSitH;
                else % - IMPAR - %
                    f_standToSit = -Fs/2+Fs/(2*N_standToSitH):Fs/N_standToSitH:Fs/2-Fs/(2*N_standToSitH);
                end

                y = fftshift(fft(standToSit)); 
                m = abs(y);
                y(m<1e-6) = 0;
                pSTSit = unwrap(angle(y)); % Phase 
              
                
                %------------------------------------------------------------------
               
                
                % - SIT TO LIE - %
                % calculo do vetor da frequencia %
                if(mode(N_sitToLieH,2)==0) % - Numero de pontos PAR - %
                    f_sitToLie = -Fs/2:Fs/N_sitToLieH:Fs/2-Fs/N_sitToLieH;
                else % - Numero de pontos IMPAR - %
                    f_sitToLie = -Fs/2+Fs/(2*N_sitToLieH):Fs/N_sitToLieH:Fs/2-Fs/(2*N_sitToLieH);
                end

                y = fftshift(fft(sitToLie)); 
                m = abs(y);
                y(m<1e-6) = 0;
                pSTL = unwrap(angle(y)); % Calculo da Phase 
                

                % ----------------------------------------------------------------------
    
                % - STAND TO LIE - %
                % calculo do vetor da frequencia %
                if(mode(N_StandToLieH,2)==0) % - Numero de pontos PAR - %
                    f_StandToLie = -Fs/2:Fs/N_StandToLieH:Fs/2-Fs/N_StandToLieH;
                else % - Numero de pontos IMPAR - %
                    f_StandToLie = -Fs/2+Fs/(2*N_StandToLieH):Fs/N_StandToLieH:Fs/2-Fs/(2*N_StandToLieH);
                end

                y = fftshift(fft(StandToLie)); 
                m = abs(y);
                y(m<1e-6) = 0;
                pSTT = unwrap(angle(y)); % Calculo da Phase 
                
                
                %----------------------------------------------------------------------
                
                % - LIE TO STAND - %
                % calculo do vetor da frequencia %
                if(mode(N_LieToStandH,2)==0) % - Numero de pontos PAR - %
                    f_LieToStand = -Fs/2:Fs/N_LieToStandH:Fs/2-Fs/N_LieToStandH;
                else % - Numero de pontos IMPAR - %
                    f_LieToStand = -Fs/2+Fs/(2*N_LieToStandH):Fs/N_LieToStandH:Fs/2-Fs/(2*N_LieToStandH);
                end

                y = fftshift(fft(LieToStand)); 
                m = abs(y);
                y(m<1e-6) = 0;
                pLST = unwrap(angle(y)); % Calculo da Phase 
                
                
                % -------------------------------------------------------------
                
                % - LIE TO SIT - %
                % calculo do vetor da frequencia %
                if(mode(N_LieToSitH,2)==0) % - Numero de pontos PAR - %
                    f_LieToSit = -Fs/2:Fs/N_LieToSitH:Fs/2-Fs/N_LieToSitH;
                else % - Numero de pontos IMPAR - %
                    f_LieToSit = -Fs/2+Fs/(2*N_LieToSitH):Fs/N_LieToSitH:Fs/2-Fs/(2*N_LieToSitH);
                end

                y = fftshift(fft(lieToSit)); 
                m = abs(y);
                y(m<1e-6) = 0;
                pLTS = unwrap(angle(y)); % Calculo da Phase 
                
                %Lie to Sit
                Phase_Magnitude("Lie to Sit",69,f_LieToSit, LTSIHamming_X, pLTS)
                
               
                
                % --------------------------------------------------------------------------
               
                % - WALKING DOWNSTAIRS - %
                % calculo do vetor da frequencia %
                if(mode(N_WalkingDownstairsH,2)==0) % - Numero de pontos PAR - %
                    f_WalkingDownstairs = -Fs/2:Fs/N_WalkingDownstairsH:Fs/2-Fs/N_WalkingDownstairsH;
                else % - Numero de pontos IMPAR - %
                    f_WalkingDownstairs = -Fs/2+Fs/(2*N_WalkingDownstairsH):Fs/N_WalkingDownstairsH:Fs/2-Fs/(2*N_WalkingDownstairsH);
                end

                y = fftshift(fft(walkingDownstairs)); 
                m = abs(y);
                y(m<1e-6) = 0;
                pWD = unwrap(angle(y)); % Calculo da Phase 
 
                %--------------------------------------------------------------
                % - WALKING - %
                % calculo do vetor da frequencia %
                if(mode(N_WalkingH,2)==0) % - Numero de pontos PAR - %
                    f_Walking = -Fs/2:Fs/N_WalkingH:Fs/2-Fs/N_WalkingH;
                else % - Numero de pontos IMPAR - %
                    f_Walking = -Fs/2+Fs/(2*N_WalkingH):Fs/N_WalkingH:Fs/2-Fs/(2*N_WalkingH);
                end

                y = fftshift(fft(walking)); 
                m = abs(y);
                y(m<1e-6) = 0;
                pW = unwrap(angle(y)); % Calculo da Phase
                
                %----------------------------------------------------------------
                 % - WALKING UPSTAIRS - %
                % calculo do vetor da frequencia %
                if(mode(WalkingUpstairsH_N,2)==0) % - Numero de pontos PAR - %
                    f_WalkingUpstairs = -Fs/2:Fs/WalkingUpstairsH_N:Fs/2-Fs/WalkingUpstairsH_N;
                else % - Numero de pontos IMPAR - %
                    f_WalkingUpstairs = -Fs/2+Fs/(2*WalkingUpstairsH_N):Fs/WalkingUpstairsH_N:Fs/2-Fs/(2*WalkingUpstairsH_N);
                end

                y = fftshift(fft(walkingUpstairs)); 
                m = abs(y);
                y(m<1e-6) = 0;
                pWU = unwrap(angle(y)); % Calculo da Phase 

                %- FIM Do CALCULOS DAS PHASES E FREQS NECESSARIAS PARA
                % DOS GRAFICOS PARA CADA MOVIMENTO
                
                
                %Construcao dos graficos de PHASE e MAGNITUDE para o ex 4.3
                %4.4 e 4.5
                
                if i==10
                    Phase_Magnitude("Standing",60,f_standing, SHamming_X, pS)

                    Phase_Magnitude("Siting",61,f_sitting, STHamming_X, pSit)

                    Phase_Magnitude("Laying",62,f_laying, LHamming_X, pL)

                    Phase_Magnitude("Sit to Stand",63,f_sitToStand, SitTSHamming_X, pSTS)

                    Phase_Magnitude("Stand to Sit",64,f_standToSit, STSHamming_X, pSTSit)

                    Phase_Magnitude("Sit to Lie",65,f_sitToLie, SitTLHamming_X, pSTL)

                    Phase_Magnitude("Stand to Lie",66,f_StandToLie, STLHamming_X, pSTT)

                    Phase_Magnitude("Lie to Stand",67,f_LieToStand, LTSHamming_X, pLST)

                    Phase_Magnitude("Lie to Sit",69,f_LieToSit, LTSIHamming_X, pLTS)

                    Phase_Magnitude("Walking",70,f_Walking, WHamming_X, pW)
                    
                    Phase_Magnitude("Walking Upstairs",71,f_WalkingUpstairs, WUHamming_X, pWU)

                    Phase_Magnitude("Walking DownStairs",72,f_WalkingDownstairs, WDHamming_X, pWD)
                end
             
        end

    end

% - -------------- EXERCICIO 5 ------------------ %


    fich = "Data\acc_exp03_user02.txt"; % - Ficheiro escolhido aleatoriamente - %
    data = importdata(fich);
    dft = abs(fftshift(fft(data)))
    window = hamming(numel(data))
    nfft = numel(dft)
    Fs = 50; 
    hopSize = length(window)/Fs

    % - Calculo da STFT - %
    stft(data,256,128,256,Fs);


    
% -----CALCULO DO DESVIO PADRAO E DA MEDIA------------- - %

    pksWMin = pkWTOTAL.*60;
    mediaW = mean(pksWMin);
    desvioW = std(pksWMin);
    n_amostraW = length(pksW);

    pksWUMin = pkWUTOTAL.*60;
    mediaWU = mean(pksWUMin);
    desvioWU = std(pksWUMin);
    n_amostraWU = length(pksWU);

    pksWDMin = pkWDTOTAL.*60;
    mediaWD = mean(pksWDMin);
    desvioWD = std(pksWDMin);
    n_amostraWD = length(pksWD);
                
     % - CRIACAO DA TABELA  - %
    Movimentos = ["Walking";"Walking Upstairs";"Walking Downstairs"];
    Media = [mediaW;mediaWU;mediaWD];
    Desvio_Padrao = [desvioW;desvioWU;desvioWD];
    N_De_Amostras = [n_amostraW;n_amostraWU;n_amostraWD];

    T = table(Movimentos,Media,Desvio_Padrao,N_De_Amostras);
    disp(T); 
    