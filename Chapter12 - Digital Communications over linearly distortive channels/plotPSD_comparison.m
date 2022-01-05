% MATLAB PROGRAM <plotPSD_comparison.m>
% This program computes the PSD of the QAM signal before and after it
% enters a good chebyshev lowpass filter prior to entering the channel
%
[Pdfy,fq]=pwelch(xchout,[],[],1024,8,'twosided'); % PSD before Tx filter
[Pdfx,fp]=pwelch(xrcos,[],[],1024,8,'twosided'); % PSD after Tx filter
figure(1);
subplot(211);semilogy(fp-f_ovsamp/2,fftshift(Pdfx),'b-');
axis([-4 4 1.e-10 1.2e0]);
xlabel('Frequency (in unit of 1/T_s)');ylabel('Power Spectrum');
title('(a) Lowpass filter input spectrum')
subplot(212);semilogy(fq-f_ovsamp/2,fftshift(Pdfy),'b-');
axis([-4 4 1.e-10 1.2e0]);
xlabel('Frequency (in unit of 1/T_s)');ylabel('Power Spectrum');
title('(b) Lowpass filter output spectrum')