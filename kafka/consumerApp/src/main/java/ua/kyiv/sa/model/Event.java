package ua.kyiv.sa.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;

@Getter
public enum Event {
    @JsonProperty("order_created")
    CREATED("order_created"),
    @JsonProperty("order_changed")
    CHANGED("order_changed"),
    @JsonProperty("order_deleted")
    DELETED("order_deleted");

    @JsonProperty
    private String event;

    Event(String event) {
        this.event = event;
    }
}
