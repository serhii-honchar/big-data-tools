package ua.kyiv.sa.service;

import ua.kyiv.sa.model.TransactionEvent;

import java.util.List;

public interface TopResultsDataHolderService {

    List<TransactionEvent> getTopResults();

    boolean processEvent(TransactionEvent event);

}
