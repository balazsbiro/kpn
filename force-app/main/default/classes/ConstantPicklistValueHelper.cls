/**
 * Created by BalazsBiro on 16/08/2022.
 */

public with sharing class ConstantPicklistValueHelper {

    private static ConstantPicklistValueHelper instance = null;
    public Map<String, String> picklistValues { get; set; }
    private ConstantPicklistValueHelper(String objectName, String picklistField) {
        picklistValues = getPicklistValuesForObjectField(objectName, picklistField);

    }
    public static ConstantPicklistValueHelper getInstance(String objectName, String picklistField) {
        instance = new ConstantPicklistValueHelper(objectName, picklistField);
        return instance;
    }

    public static Map<String, String> getPicklistValuesForObjectField(String objectName, String picklistField) {
        Map<String, String> picklistValues = new Map<String, String>();
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
        Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
        for (Schema.PicklistEntry objPickList : mapFields.get(picklistField).getDescribe().getPicklistValues()) {
            if (objPickList.isActive()) {
                picklistValues.put(objPickList.getLabel(), objPickList.getValue());
            }
        }
        return picklistValues;
    }
}
