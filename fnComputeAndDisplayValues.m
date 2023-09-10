function [omFin, accFin, OMFIN, ACCFIN, f] = fnComputeAndDisplayValues(acc, om, fs)
    % Get user input for the time interval
   
    fig = figure;
    subplot(221), plot(acc)
    xlabel('$n$', 'interpreter', 'latex'), ylabel('$acc\[g]$', 'interpreter', 'latex')
    subplot(222), plot(om)
    xlabel('$n$', 'interpreter', 'latex'), ylabel('$\Omega\[f]$', 'interpreter', 'latex')
    x = ginput(2);
    x = round(x);
    close(fig);

    nStart = x(1);
    nEnd = x(2);

    omFin = om(nStart:nEnd, :);
    accFin = acc(nStart:nEnd, :) * 9.87;

    omFin = deg2rad(omFin);

    [~, OMFIN, ~] = fnFFT(omFin);
    [~, ACCFIN, ~] = fnFFT(accFin);
    f = linspace(0, fs, length(omFin));

    % Create and display plots
    figure;
    subplot(221), plot(omFin)
    xlabel('$n$', 'interpreter', 'latex'), ylabel('$om\ [n]$', 'interpreter', 'latex')
    subplot(222), plot(accFin)
    xlabel('$n$', 'interpreter', 'latex'), ylabel('$acc\ [n]$', 'interpreter', 'latex')
    subplot(223), plot(f, OMFIN)
    xlabel('$f$', 'interpreter', 'latex'), ylabel('$A_{om}\ (f)$', 'interpreter', 'latex')
    subplot(224), plot(f, ACCFIN)
    xlabel('$f$', 'interpreter', 'latex'), ylabel('$A_{acc}\ (f)$', 'interpreter', 'latex')
end