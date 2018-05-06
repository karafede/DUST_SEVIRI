plot(SDF_AOD_500_Masdar_Institute_15(:,1),SDF_AOD_500_Masdar_Institute_15(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_500_Masdar_Institute_15(:,1),SDF_AOD_500_Masdar_Institute_15(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Jun 2012 - Mar 2013)')
ylabel('AOD 500')
l = legend('No SDF','SDF present');
xlim([SDF_AOD_500_Masdar_Institute_15(1,1) SDF_AOD_500_Masdar_Institute_15(26016,1)])
datetick('x','mmm','keeplimits')
title('Masdar Institute 15')


plot(SDF_AOD_500_Mezaira_15(:,1),SDF_AOD_500_Mezaira_15(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_500_Mezaira_15(:,1),SDF_AOD_500_Mezaira_15(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (2012)')
ylabel('AOD 500')
l1 = legend('No SDF','SDF present');
xlim([SDF_AOD_500_Mezaira_15(1,1) SDF_AOD_500_Mezaira_15(9024,1)])
datetick('x','mmm','keeplimits')
title('Mezaira 15')


plot(SDF_AOD_Masdar_Institute_15(:,1),SDF_AOD_Masdar_Institute_15(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_Masdar_Institute_15(:,1),SDF_AOD_Masdar_Institute_15(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Jun 2012 - Mar 2013)')
ylabel('AOD 550')
l = legend('No SDF','SDF present');
xlim([SDF_AOD_Masdar_Institute_15(1,1) SDF_AOD_Masdar_Institute_15(26016,1)])
datetick('x','mmm','keeplimits')
title('Masdar Institute 15')


plot(SDF_AOD_Mezaira_15(:,1),SDF_AOD_Mezaira_15(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_Mezaira_15(:,1),SDF_AOD_Mezaira_15(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (2012)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
xlim([SDF_AOD_Mezaira_15(1,1) SDF_AOD_Mezaira_15(9024,1)])
datetick('x','mmm','keeplimits')
title('Mezaira 15')


plot(SDF_AOD_550_Abu_Al_Bukhoosh(:,1),SDF_AOD_550_Abu_Al_Bukhoosh(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Abu_Al_Bukhoosh(:,1),SDF_AOD_550_Abu_Al_Bukhoosh(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Sep 2004 - Jun 2007)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Abu_Al_Bukhoosh(1,1) SDF_AOD_550_Abu_Al_Bukhoosh(61854,1)])
datetick('x','mmm','keeplimits')
title('Abu Al Bukhoosh')


plot(SDF_AOD_550_Abu_Dhabi(:,1),SDF_AOD_550_Abu_Dhabi(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Abu_Dhabi(:,1),SDF_AOD_550_Abu_Dhabi(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Aug 2004 - Jul 2005)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Abu_Dhabi(1,1) SDF_AOD_550_Abu_Dhabi(25742,1)])
datetick('x','mmm','keeplimits')
title('Abu Dhabi')


plot(SDF_AOD_550_Al_Ain(:,1),SDF_AOD_550_Al_Ain(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Al_Ain(:,1),SDF_AOD_550_Al_Ain(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Aug 2006 - Oct 2006)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Al_Ain(1,1) SDF_AOD_550_Al_Ain(3233,1)])
datetick('x','mmm','keeplimits')
title('Al Ain')


plot(SDF_AOD_550_Al_Khaznah(:,1),SDF_AOD_550_Al_Khaznah(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Al_Khaznah(:,1),SDF_AOD_550_Al_Khaznah(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Jun 2004 - Sep 2004)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Al_Khaznah(1,1) SDF_AOD_550_Al_Khaznah(6771,1)])
datetick('x','mmm','keeplimits')
title('Al Khaznah')


plot(SDF_AOD_550_Al_Qlaa(:,1),SDF_AOD_550_Al_Qlaa(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Al_Qlaa(:,1),SDF_AOD_550_Al_Qlaa(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Jun 2004 - Aug 2004)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Al_Qlaa(1,1) SDF_AOD_550_Al_Qlaa(3904,1)])
datetick('x','mmm','keeplimits')
title('Al Qlaa')


plot(SDF_AOD_550_Dalma(:,1),SDF_AOD_550_Dalma(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Dalma(:,1),SDF_AOD_550_Dalma(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Jul 2004 - Dec 2004)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Dalma(1,1) SDF_AOD_550_Dalma(10004,1)])
datetick('x','mmm','keeplimits')
title('Dalma')


plot(SDF_AOD_550_Dhabi(:,1),SDF_AOD_550_Dhabi(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Dhabi(:,1),SDF_AOD_550_Dhabi(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Apr 2004 - Sep 2008)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Dhabi(1,1) SDF_AOD_550_Dhabi(108946,1)])
datetick('x','mmm','keeplimits')
title('Dhabi')


plot(SDF_AOD_550_Dhadnah(:,1),SDF_AOD_550_Dhadnah(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Dhadnah(:,1),SDF_AOD_550_Dhadnah(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Jun 2004 - Jun 2007)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Dhadnah(1,1) SDF_AOD_550_Dhadnah(65392,1)])
datetick('x','mmm','keeplimits')
title('Dhadnah')


plot(SDF_AOD_550_Hamim(:,1),SDF_AOD_550_Hamim(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Hamim(:,1),SDF_AOD_550_Hamim(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Jun 2004 - Aug 2007)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Hamim(1,1) SDF_AOD_550_Hamim(69662,1)])
datetick('x','mmm','keeplimits')
title('Hamim')


plot(SDF_AOD_550_Jabal_Hafeet(:,1),SDF_AOD_550_Jabal_Hafeet(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Jabal_Hafeet(:,1),SDF_AOD_550_Jabal_Hafeet(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Jun 2004 - Oct 2004)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Jabal_Hafeet(1,1) SDF_AOD_550_Jabal_Hafeet(6649,1)])
datetick('x','mmm','keeplimits')
title('Jabal Hafeet')


plot(SDF_AOD_550_MAARCO(:,1),SDF_AOD_550_MAARCO(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_MAARCO(:,1),SDF_AOD_550_MAARCO(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Aug 2004 - Oct 2004)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_MAARCO(1,1) SDF_AOD_550_MAARCO(3416,1)])
datetick('x','mmm','keeplimits')
title('MAARCO')


plot(SDF_AOD_550_Mezaira(:,1),SDF_AOD_550_Mezaira(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Mezaira(:,1),SDF_AOD_550_Mezaira(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Jun 2004 - Feb 2011)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Mezaira(1,1) SDF_AOD_550_Mezaira(149023,1)])
datetick('x','mmm','keeplimits')
title('Mezaira 20')


plot(SDF_AOD_550_Mussafa(:,1),SDF_AOD_550_Mussafa(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Mussafa(:,1),SDF_AOD_550_Mussafa(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Oct 2004 - Sep 2010)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Mussafa(1,1) SDF_AOD_550_Mussafa(133163,1)])
datetick('x','mmm','keeplimits')
title('Mussafa')


plot(SDF_AOD_550_Saih_Salam(:,1),SDF_AOD_550_Saih_Salam(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Saih_Salam(:,1),SDF_AOD_550_Saih_Salam(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Jun 2004 - Oct 2004)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Saih_Salam(1,1) SDF_AOD_550_Saih_Salam(6893,1)])
datetick('x','mmm','keeplimits')
title('Saih Salam')


plot(SDF_AOD_550_Sir_Bu_Nuair(:,1),SDF_AOD_550_Sir_Bu_Nuair(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Sir_Bu_Nuair(:,1),SDF_AOD_550_Sir_Bu_Nuair(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Aug 2004 - Oct 2004)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Sir_Bu_Nuair(1,1) SDF_AOD_550_Sir_Bu_Nuair(3782,1)])
datetick('x','mmm','keeplimits')
title('Sir Bu Nuair')


plot(SDF_AOD_550_SMART(:,1),SDF_AOD_550_SMART(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_SMART(:,1),SDF_AOD_550_SMART(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Aug 2004 - Oct 2004)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_SMART(1,1) SDF_AOD_550_SMART(3355,1)])
datetick('x','mmm','keeplimits')
title('SMART')


plot(SDF_AOD_550_Umm_Al_Quwain(:,1),SDF_AOD_550_Umm_Al_Quwain(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_550_Umm_Al_Quwain(:,1),SDF_AOD_550_Umm_Al_Quwain(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Oct 2004 - Oct 2004)')
ylabel('AOD 550')
l1 = legend('No SDF','SDF present');
% xlim([SDF_AOD_550_Umm_Al_Quwain(1,1) SDF_AOD_550_Umm_Al_Quwain(732,1)])
datetick('x','mmm','keeplimits')
title('Umm Al Quwain')