export type InvoiceProps = {
    id: number;
    invoice_id: string;
    receiver_name: string;
    receiver_citizenid: string;
    receiver_job: string;
    author_name: string;
    author_citizenid: string;
    author_job: string;
    amount: number;
    total: number;
    vat: number;
    item: string;
    note: string;
    created_date: number;
    status: string
}