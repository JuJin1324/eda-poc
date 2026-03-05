package com.jujin.edapoc.shared.contract.api;

public record OrderResponse(
        String orderId,
        OrderStatus status
) {
}
