package ua.kyiv.sa.listener;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.Acknowledgment;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;
import ua.kyiv.sa.model.TransactionEvent;
import ua.kyiv.sa.service.TopResultsDataHolderService;

import java.util.List;

import static java.util.stream.Collectors.joining;

@Slf4j
@Service
public class MessageListener {

    @Autowired
    private TopResultsDataHolderService topResultsDataHolderServiceImpl;

    @KafkaListener(topics = {"btc-transactions"}, groupId = "procamp-group", containerFactory = "kafkaListenerContainerFactory")
    public void listenBtcTransactionTopic(final @Payload TransactionEvent message,
                                          final @Header(KafkaHeaders.OFFSET) Integer offset,
                                          final @Header(KafkaHeaders.RECEIVED_TOPIC) String receivedTopic,
                                          final @Header(KafkaHeaders.RECEIVED_PARTITION_ID) Long partitionId,
                                          final @Header(KafkaHeaders.RECEIVED_TIMESTAMP) Long receivedTs,
                                          final @Header(KafkaHeaders.GROUP_ID) String groupId,
                                          final Acknowledgment acknowledgment) {
        log.info(String.format("#### -> Consumed message -> TIMESTAMP: %d\n%s\noffset: %d\npartition: %d\ntopic: %s \ngroupId: %s", receivedTs, message.toString(), offset, partitionId, receivedTopic, groupId));
        topResultsDataHolderServiceImpl.processEvent(message);
        List<TransactionEvent> topResults = topResultsDataHolderServiceImpl.getTopResults();
        log.info("Top 10 transactions: \n{}", topResults.stream().map(TransactionEvent::toString).collect(joining("\n")));
        acknowledgment.acknowledge();
    }
}
