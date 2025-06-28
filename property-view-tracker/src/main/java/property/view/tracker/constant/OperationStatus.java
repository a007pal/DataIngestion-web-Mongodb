package property.view.tracker.constant;

import lombok.Getter;

@Getter
public enum OperationStatus {
    SUCCESS("S"),
    FAILED("F");
    private final String  statusName;
    OperationStatus(String statusName) {
        this.statusName = statusName;
    }
}
