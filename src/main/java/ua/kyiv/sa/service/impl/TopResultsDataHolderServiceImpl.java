package ua.kyiv.sa.service.impl;

import org.springframework.stereotype.Component;
import ua.kyiv.sa.model.TransactionEvent;
import ua.kyiv.sa.service.TopResultsDataHolderService;

import java.util.List;

@Component
public class TopResultsDataHolderServiceImpl implements TopResultsDataHolderService {

    @Override
    public List<TransactionEvent> getTopResults() {
        return null;
    }

    @Override
    public boolean processEvent(TransactionEvent event) {
        return false;
    }
}
