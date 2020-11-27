package ua.kyiv.sa.model;

import lombok.Getter;

@Getter
public enum OrderType {
    BUY(0),
    SELL(1);

    private int value;

    OrderType(int value) {
        this.value = value;
    }
}
