import java.io.*;
import javax.xml.stream.*;
import java.util.regex.Pattern;

/**
 * Utility class for processing XML files by removing spaces between tags.
 * Designed to handle XML files up to 200MB efficiently with streaming.
 */
public class XMLSpaceRemover {

    private static final int BUFFER_SIZE = 8192;

    /**
     * Removes spaces between XML tags using efficient streaming approach.
     * Example: "<test>      </test>" becomes "<test></test>"
     *
     * @param inputStream the input XML as an InputStream
     * @return an InputStream containing the processed XML
     * @throws IOException if an I/O error occurs
     */
    public static InputStream removeSpacesBetweenTags(InputStream inputStream) throws IOException {
        if (inputStream == null) {
            throw new IllegalArgumentException("Input stream cannot be null");
        }

        File tempOutputFile = File.createTempFile("processed_xml_", ".tmp");
        tempOutputFile.deleteOnExit();
        
        try (BufferedOutputStream outputStream = new BufferedOutputStream(
                new FileOutputStream(tempOutputFile), BUFFER_SIZE)) {
            
            processXmlStream(inputStream, outputStream);
        } catch (XMLStreamException e) {
            throw new IOException("Error processing XML stream", e);
        }
        
        // Return the processed content as an InputStream
        return new BufferedInputStream(new FileInputStream(tempOutputFile), BUFFER_SIZE);
    }
    
    /**
     * Universal method that can handle any XML processing with spaces between tags.
     * This method is designed to efficiently process large XML files (up to 200MB).
     *
     * @param inputStream the input XML as an InputStream
     * @return an InputStream containing the processed XML
     * @throws IOException if an I/O error occurs
     */
    public static InputStream processXML(InputStream inputStream) throws IOException {
        return removeSpacesBetweenTags(inputStream);
    }

    /**
     * Process XML using StAX parser for memory efficiency.
     * 
     * @param input the input XML stream
     * @param output the output stream where processed XML will be written
     * @throws XMLStreamException if XML parsing error occurs
     * @throws IOException if I/O error occurs
     */
    private static void processXmlStream(InputStream input, OutputStream output) 
            throws XMLStreamException, IOException {
        
        XMLInputFactory inputFactory = XMLInputFactory.newInstance();
        // Disable external entity resolution for security
        inputFactory.setProperty(XMLInputFactory.IS_SUPPORTING_EXTERNAL_ENTITIES, Boolean.FALSE);
        inputFactory.setProperty(XMLInputFactory.SUPPORT_DTD, Boolean.FALSE);
        
        XMLStreamReader reader = inputFactory.createXMLStreamReader(input);
        XMLOutputFactory outputFactory = XMLOutputFactory.newInstance();
        XMLStreamWriter writer = outputFactory.createXMLStreamWriter(output);
        
        // Track state to detect whitespace-only content
        String currentElement = null;
        StringBuilder contentBuffer = new StringBuilder();
        boolean hasNonWhitespace = false;
        
        while (reader.hasNext()) {
            int event = reader.next();
            
            switch (event) {
                case XMLStreamConstants.START_DOCUMENT:
                    writer.writeStartDocument(reader.getEncoding(), reader.getVersion());
                    break;
                    
                case XMLStreamConstants.END_DOCUMENT:
                    writer.writeEndDocument();
                    break;
                    
                case XMLStreamConstants.START_ELEMENT:
                    // If we were tracking content for a previous element, write it now
                    if (currentElement != null && contentBuffer.length() > 0) {
                        if (hasNonWhitespace) {
                            writer.writeCharacters(contentBuffer.toString());
                        }
                        contentBuffer.setLength(0);
                        hasNonWhitespace = false;
                    }
                    
                    currentElement = reader.getLocalName();
                    writer.writeStartElement(reader.getPrefix(), reader.getLocalName(), 
                            reader.getNamespaceURI());
                    
                    // Write all namespace declarations
                    for (int i = 0; i < reader.getNamespaceCount(); i++) {
                        writer.writeNamespace(reader.getNamespacePrefix(i), 
                                reader.getNamespaceURI(i));
                    }
                    
                    // Write all attributes
                    for (int i = 0; i < reader.getAttributeCount(); i++) {
                        writer.writeAttribute(reader.getAttributePrefix(i),
                                reader.getAttributeNamespace(i),
                                reader.getAttributeLocalName(i),
                                reader.getAttributeValue(i));
                    }
                    break;
                    
                case XMLStreamConstants.END_ELEMENT:
                    // If we have content for the current element
                    if (currentElement != null && currentElement.equals(reader.getLocalName())) {
                        if (contentBuffer.length() > 0) {
                            // Only write content if it's not just whitespace
                            if (hasNonWhitespace) {
                                writer.writeCharacters(contentBuffer.toString());
                            }
                            contentBuffer.setLength(0);
                        }
                        hasNonWhitespace = false;
                    }
                    
                    writer.writeEndElement();
                    currentElement = null;
                    break;
                    
                case XMLStreamConstants.CHARACTERS:
                    if (currentElement != null) {
                        String text = reader.getText();
                        contentBuffer.append(text);
                        // Check if content has non-whitespace
                        if (!hasNonWhitespace && !Pattern.matches("\\s*", text)) {
                            hasNonWhitespace = true;
                        }
                    }
                    break;
                    
                case XMLStreamConstants.CDATA:
                    writer.writeCData(reader.getText());
                    break;
                    
                case XMLStreamConstants.COMMENT:
                    writer.writeComment(reader.getText());
                    break;
                    
                case XMLStreamConstants.PROCESSING_INSTRUCTION:
                    writer.writeProcessingInstruction(reader.getPITarget(), reader.getPIData());
                    break;
                    
                case XMLStreamConstants.DTD:
                    writer.writeDTD(reader.getText());
                    break;
                    
                case XMLStreamConstants.ENTITY_REFERENCE:
                    writer.writeEntityRef(reader.getLocalName());
                    break;
            }
        }
        
        writer.flush();
        writer.close();
        reader.close();
    }

    /**
     * Example usage of the XML space remover utility.
     */
    public static void main(String[] args) {
        try {
            // Example XML with spaces between tags
            String xml = "<root>\n  <test>      </test>\n  <another>content</another>\n</root>";
            InputStream inputStream = new ByteArrayInputStream(xml.getBytes());
            
            // Process the XML
            InputStream result = processXML(inputStream);
            
            // Print the result
            BufferedReader reader = new BufferedReader(new InputStreamReader(result));
            String line;
            System.out.println("Processed XML:");
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Processes a large XML file from an input file path and saves the result to an output file path.
     * Suitable for handling files up to 200MB.
     * 
     * @param inputFilePath path to the input XML file
     * @param outputFilePath path where the processed XML will be saved
     * @throws IOException if an I/O error occurs
     */
    public static void processLargeXmlFile(String inputFilePath, String outputFilePath) throws IOException {
        try (InputStream inputStream = new BufferedInputStream(new FileInputStream(inputFilePath), BUFFER_SIZE);
             OutputStream outputStream = new BufferedOutputStream(new FileOutputStream(outputFilePath), BUFFER_SIZE)) {
            
            InputStream processedStream = processXML(inputStream);
            
            // Transfer processed content to output file
            byte[] buffer = new byte[BUFFER_SIZE];
            int bytesRead;
            while ((bytesRead = processedStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            
            processedStream.close();
        }
    }
}
