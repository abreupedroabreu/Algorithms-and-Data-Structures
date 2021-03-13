
function janelasDeslizantes(window,tt_ActivityHamming, ActivityHamming_X, tt_ActivityBackman, X_ActivityBackman,tt_ActivityFlatTop,X_ActFlatTop)
        
        %- JANELAS DESLIZANTES
        %HAMMING
        
        figure(window)
        subplot(3,1,1);
        plot(tt_ActivityHamming,ActivityHamming_X,"k")
        ylabel("T[s]","fontsize",12,"fontweight","bold")
        xlabel("DFT","fontsize",12,"fontweight","bold")
        title("Janela de Hamming")

        subplot(3,1,2);
        
        % BACKMAN
        
        plot(tt_ActivityBackman,X_ActivityBackman,"k")
        ylabel("T[s]","fontsize",12,"fontweight","bold")
        xlabel("DFT","fontsize",12,"fontweight","bold")
        title("Backman Window")

        % FLAT TOP
        
        subplot(3,1,3);
        plot(tt_ActivityFlatTop,X_ActFlatTop,"k")
        ylabel("T[s]","fontsize",12,"fontweight","bold")
        xlabel("DFT","fontsize",12,"fontweight","bold")
        title("Janela Flat Top")

end