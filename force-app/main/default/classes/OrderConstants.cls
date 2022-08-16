/**
 * Created by BalazsBiro on 16/08/2022.
 */

public with sharing class OrderConstants {

    public static final String STATUS_DRAFT = 'Draft';
    public static final String STATUS_ACTIVATED = 'Activated';

    public static final Map<String, String> STATUSES {
        get {
            if (STATUSES == null) {
                ConstantPicklistValueHelper constantPicklistValueHelper = ConstantPicklistValueHelper.getInstance('Order', 'Status');
                STATUSES = constantPicklistValueHelper.picklistValues;
            }
            return STATUSES;
        }
        set;
    }
}