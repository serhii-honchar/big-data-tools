package ua.kyiv.sa.listener;

import lombok.SneakyThrows;
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

@Slf4j
@Service
public class MessageListener {

    private static final String LOG_MESSAGE = "#### -> Consumed message {} -> TIMESTAMP: {}\n" +
            "message: {}\n" +
            "price: {}\n" +
            "offset: {}\n" +
            "partition: {}\n" +
            "topic: {} \n" +
            "groupId: {} \n";

    @Autowired
    private TopResultsDataHolderService topResultsDataHolderServiceImpl;

    @KafkaListener(topics = {"btc-transactions"},
            groupId = "procamp-group",
            containerFactory = "kafkaListenerContainerFactory")
    @SneakyThrows
    public void listenBtcTransactionTopic(final @Payload TransactionEvent message,
                                          final @Header(KafkaHeaders.OFFSET) Integer offset,
                                          final @Header(KafkaHeaders.RECEIVED_TOPIC) String receivedTopic,
                                          final @Header(KafkaHeaders.RECEIVED_PARTITION_ID) Long partitionId,
                                          final @Header(KafkaHeaders.RECEIVED_TIMESTAMP) Long receivedTs,
                                          final @Header(KafkaHeaders.GROUP_ID) String groupId,
                                          final Acknowledgment acknowledgment) {

        //check received message and print it
        boolean valid = isValidMessage(message);
        log.info(LOG_MESSAGE, valid ? "valid" : "invalid", receivedTs, message.toString(), message.getData().getPrice(), offset, partitionId, receivedTopic, groupId);

        if (valid) {
            //process valid message
            Thread.sleep(1000L);
            topResultsDataHolderServiceImpl.processEvent(message);
        }

        //commit offset
        acknowledgment.acknowledge();
    }

    private boolean isValidMessage(TransactionEvent event) {
        return event.getData() != null && event.getData().getPrice() != null;
    }
}
