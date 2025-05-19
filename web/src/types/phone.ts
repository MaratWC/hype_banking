import type { InvoiceProps } from "./invoices";

export type PhoneDataProps = {
    name: string;
    balance: number;
    id: string;
    invoices: InvoiceProps[];
}