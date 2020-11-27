package ua.kyiv.sa.model;

import lombok.Data;

import java.io.Serializable;

@Data
public class TransactionEvent implements Serializable {
    private TransactionDetail data;
    private String channel;
    private String event;
}
