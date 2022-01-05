% MATLAB PROGRAM <plotQAM_results.m>
% This program plots symbol error rate comparison before and after equalization
% constellation points
% eye-diagrams before equalization

figure(2)
subplot(111)
figber=semilogy(Eb2Naz,Q,'k-',Eb2N,SERneq,'b-o',Eb2N,SEReq,'b-v');
axis([0 26 .99e-5 1]);
legend('Analytical', 'Without equalizer', 'With equalizer');
xlabel('E_b/N (dB)');ylabel('Symbol error probability');
set(figber,'Linewidth',2);
% Constellation plot before and after equalization
figure(3)
subplot(121)
plot(real(z1(1:min(L,4000))),imag(z1(1:min(L,4000))),'.');
axis('square')
xlabel('Real part')
title('(a) Before equalization')
ylabel('Imaginary part');
subplot(122)
plot(real(dsig(1:min(L,4000))),imag(dsig(1:min(L,4000))),'.');
axis('square')
title('(b) After equalization')
xlabel('Real part')
ylabel('Imaginary part');
figure(4)
t=length(h);
plot([1:t]/f_ovsamp,h);

xlabel('time (in unit of T_s)')
title('Multipath channel impulse response');
% Plot eye diagrams due to multipath channel
eyevec=conv(xchout,prcos);
eyevec=eyevec(delaychb+1:(delaychb+800)*f_ovsamp);
eyediagram(real(eyevec),16,2);
title('Eye diagram (in-phase component)');
xlabel('Time (in unit of T_s)');