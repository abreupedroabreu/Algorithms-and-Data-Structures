function Phase_Magnitude(nome,window,freq_Activity, Activity_Hamming_X, phase_Activity)


    figure(window)
    
    subplot(2,1,1);

    plot(freq_Activity,Activity_Hamming_X,"k")


    ylabel("Magnitude ","fontsize",12,"fontweight","bold")
    xlabel("Frequencia(Hz)","fontsize",12,"fontweight","bold")
    title(nome)
    axis tight

    subplot(2,1,2);

    plot(freq_Activity,phase_Activity,"k")


    ylabel("Phase","fontsize",12,"fontweight","bold")
    xlabel("Frequencia(Hz)","fontsize",12,"fontweight","bold")
    axis tight
    
end