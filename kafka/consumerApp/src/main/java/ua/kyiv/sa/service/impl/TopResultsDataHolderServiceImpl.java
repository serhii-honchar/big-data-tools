package ua.kyiv.sa.service.impl;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import ua.kyiv.sa.model.TransactionEvent;
import ua.kyiv.sa.service.TopResultsDataHolderService;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.PriorityQueue;
import java.util.concurrent.atomic.AtomicLong;

import static java.util.stream.Collectors.joining;

@Component
@Slf4j
public class TopResultsDataHolderServiceImpl implements TopResultsDataHolderService {

    private static final Comparator<TransactionEvent> PRICE_COMPARATOR = Comparator.comparing(x -> x.getData().getPrice());
    private static final Comparator<TransactionEvent> PRICE_COMPARATOR_REV = Comparator.comparing(x -> x.getData().getPrice(), Comparator.reverseOrder());
    private static final PriorityQueue<TransactionEvent> TOP_TRANSACTIONS = new PriorityQueue<>(PRICE_COMPARATOR);
    private static final AtomicLong TOTAL_MESSAGES_COUNT = new AtomicLong(0);
    private static final AtomicLong LAST_LEG_MESSAGES_COUNT = new AtomicLong(0);
    private static final String MESSAGE_PATTERN = "\n#####################\n" +
            "Total messages count = {}\n" +
            "Messages processed during last period = {}\n" +
            "Top 10 transations:\n{}\n" +
            "#####################\n";

    @Override
    public List<TransactionEvent> getTopResults() {
        //return a copy of top results
        return new ArrayList<>(TOP_TRANSACTIONS);
    }

    @Override
    public void processEvent(TransactionEvent event) {
        //add to priority queue
        TOP_TRANSACTIONS.add(event);

        //remove smallest value from queue after one transaction was added
        if (TOP_TRANSACTIONS.size() > 10) {
            TOP_TRANSACTIONS.poll();
        }

        //increment counters
        LAST_LEG_MESSAGES_COUNT.getAndIncrement();
        TOTAL_MESSAGES_COUNT.getAndIncrement();
    }


    //print actual results every 10 seconds
    @Scheduled(cron = "${cron:*/10 * * * * *}")
    private void printCurrentResults() {
        //log top events
        String topTransactions = TOP_TRANSACTIONS.stream().sorted(PRICE_COMPARATOR_REV)
                .map(TransactionEvent::toString).collect(joining("\n"));
        log.info(MESSAGE_PATTERN, TOTAL_MESSAGES_COUNT.get(), LAST_LEG_MESSAGES_COUNT.get(), topTransactions);

        //reset counter of messages processed during last leg
        LAST_LEG_MESSAGES_COUNT.set(0);
    }
}
