public with sharing class SabrePNRUpdateInboundRequest {

    public class PNRCHNG {

        public String notificationType {get;set;}
        public String ownPCC {get;set;}
        public String homePCC {get;set;}
        public String locator {get;set;}

        public Boolean itineraryHasChanged {get;set;}
        public Boolean passangerDetailHasChanged {get;set;}
        public Boolean remarksHasChanged {get;set;}

    }

    public static PNRCHNG parsePnrChange(string xmlInput){

        PNRCHNG event = new PNRCHNG();

        DOM.Document doc = new Dom.Document();
        doc.load(xmlInput);
        System.debug(doc.toXmlString());
        DOM.XMLNode root = doc.getRootElement();
        System.debug(root);
        List<DOM.XMLNode> envChildrenList = root.getChildElements();
        System.debug(envChildrenList);
        for (DOM.XMLNode bodyNode : envChildrenList) {
            System.debug(bodyNode.getName());
            if (bodyNode.getName() == 'Body') {
                List<DOM.XmlNode> bodyChilderenList = bodyNode.getChildElements();
                for (DOM.XmlNode getBATCHNode : bodyChilderenList) {
                    System.debug(getBATCHNode.getName());
                    if (getBATCHNode.getName() == 'BATCH.NOTIFICATION') {
                        event.notificationType = getBATCHNode.getAttributeValue(getBATCHNode.getAttributeKeyAt(0),getBATCHNode.getAttributeKeyNsAt(0));
                        List<DOM.XmlNode> getBATCHChildrenList = getBATCHNode.getChildElements();
                        for (DOM.XMLNode getPNRCHNGNode : getBATCHChildrenList) {
                            if (getPNRCHNGNode.getName() == 'CCC.PNRCHNG') {
                                List<DOM.XmlNode> getPNRCHNGChildrenList = getPNRCHNGNode.getChildElements();
                                for (DOM.XMLNode pnrchngNode : getPNRCHNGChildrenList) {
                                    if (pnrchngNode.getName() == 'OWNPCC') {
                                        event.ownPCC = pnrchngNode.getText();
                                    } else if (pnrchngNode.getName() == 'HOMEPCC') {
                                        event.homePCC = pnrchngNode.getText();
                                    } else if (pnrchngNode.getName() == 'Locator') {
                                        event.locator = pnrchngNode.getText();
                                    } else if (pnrchngNode.getName() == 'ChangeIndicators') {
                                        List<DOM.XMLNode> changeIndicators = pnrchngNode.getChildElements();
                                        for (DOM.XMLNode changeIndicatorNode : changeIndicators) {
                                            if (changeIndicatorNode.getAttributeValue(changeIndicatorNode.getAttributeKeyAt(0), changeIndicatorNode.getAttributeKeyNsAt(0)) == 'Itinerary') {
                                                List<DOM.XMLNode> indicators = changeIndicatorNode.getChildElements();
                                                for (DOM.XMLNode indicatorNode : indicators) {
                                                    System.debug(indicatorNode.getName());
                                                    if (indicatorNode.getName() == 'hasChanged') {
                                                        if (indicatorNode.getText() == 'Y') {
                                                            event.itineraryHasChanged = true;
                                                        } else {
                                                            event.itineraryHasChanged = false;
                                                        }
                                                    }
                                                }
                                            } else if (changeIndicatorNode.getAttributeValue(changeIndicatorNode.getAttributeKeyAt(0), changeIndicatorNode.getAttributeKeyNsAt(0)) == 'Passenger Detail') {
                                                List<DOM.XMLNode> indicators = changeIndicatorNode.getChildElements();
                                                for (DOM.XMLNode indicatorNode : indicators) {
                                                    if (indicatorNode.getName() == 'hasChanged') {
                                                        if (indicatorNode.getText() == 'Y') {
                                                            event.itineraryHasChanged = true;
                                                        } else {
                                                            event.itineraryHasChanged = false;
                                                        }
                                                    }
                                                }
                                            } else if (changeIndicatorNode.getAttributeValue(changeIndicatorNode.getAttributeKeyAt(0), changeIndicatorNode.getAttributeKeyNsAt(0)) == 'Remarks') {
                                                List<DOM.XMLNode> indicators = changeIndicatorNode.getChildElements();
                                                for (DOM.XMLNode indicatorNode : indicators) {
                                                    if (indicatorNode.getName() == 'hasChanged') {
                                                        if (indicatorNode.getText() == 'Y') {
                                                            event.itineraryHasChanged = true;
                                                        } else {
                                                            event.itineraryHasChanged = false;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return event;
    }

}