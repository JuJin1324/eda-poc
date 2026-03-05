package com.jujin.edapoc.shared.contract.event;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.OffsetDateTime;

public record OrderCompletedEvent(
        String eventId,
        @JsonFormat(shape = JsonFormat.Shape.STRING) OffsetDateTime occurredAt,
        String orderId,
        String productId,
        int quantity,
        String customerId
) {
}
